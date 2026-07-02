#include "userprog/syscall.h"
#include "filesys/file.h"
#include "filesys/filesys.h"
#include "lib/round.h"
#include "threads/interrupt.h"
#include "threads/palloc.h"
#include "threads/thread.h"
#include "threads/vaddr.h"
#include "userprog/pagedir.h"
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <syscall-nr.h>

static void syscall_handler(struct intr_frame*);

void syscall_init(void) { intr_register_int(0x30, 3, INTR_ON, syscall_handler, "syscall"); }

void syscall_exit(int status) {
  printf("%s: exit(%d)\n", thread_current()->name, status);
  thread_exit();
}

/*
 * This does not check that the buffer consists of only mapped pages; it merely
 * checks the buffer exists entirely below PHYS_BASE.
 */
static void validate_buffer_in_user_region(const void* buffer, size_t length) {
  uintptr_t delta = PHYS_BASE - buffer;
  if (!is_user_vaddr(buffer) || length > delta)
    syscall_exit(-1);
}

/*
 * This does not check that the string consists of only mapped pages; it merely
 * checks the string exists entirely below PHYS_BASE.
 */
static void validate_string_in_user_region(const char* string) {
  uintptr_t delta = PHYS_BASE - (const void*)string;
  if (!is_user_vaddr(string) || strnlen(string, delta) == delta)
    syscall_exit(-1);
}

static int syscall_open(const char* filename) {
  struct thread* t = thread_current();
  if (t->open_file != NULL)
    return -1;

  t->open_file = filesys_open(filename);
  if (t->open_file == NULL)
    return -1;

  return 2;
}

static int syscall_write(int fd, void* buffer, unsigned size) {
  struct thread* t = thread_current();
  if (fd == STDOUT_FILENO) {
    putbuf(buffer, size);
    return size;
  } else if (fd != 2 || t->open_file == NULL)
    return -1;

  return (int)file_write(t->open_file, buffer, size);
}

static int syscall_read(int fd, void* buffer, unsigned size) {
  struct thread* t = thread_current();
  if (fd != 2 || t->open_file == NULL)
    return -1;

  return (int)file_read(t->open_file, buffer, size);
}

static void syscall_close(int fd) {
  struct thread* t = thread_current();
  if (fd == 2 && t->open_file != NULL) {
    file_close(t->open_file);
    t->open_file = NULL;
  }
}

static void* syscall_sbrk(intptr_t increment) {
  struct thread* t = thread_current();
  uint8_t* old_break = t->heap_end;
  uint8_t* new_break = old_break + increment;

  if (increment == 0)
    return old_break;

  /* Check for overflow (positive or negative) */
  if (increment > 0 && new_break < old_break)
    return (void*)-1;
  if (increment < 0 && new_break > old_break)
    return (void*)-1;

  /* Check bounds: don't shrink past heap start, don't grow into kernel space */
  if (new_break < t->heap_start)
    return (void*)-1;
  if ((uint32_t)new_break >= (uint32_t)PHYS_BASE)
    return (void*)-1;

  uint8_t* old_page_bound = (uint8_t*)ROUND_UP((uint32_t)old_break, PGSIZE);
  uint8_t* new_page_bound = (uint8_t*)ROUND_UP((uint32_t)new_break, PGSIZE);

  if (increment > 0) {
    if (new_page_bound > old_page_bound) {
      uint8_t* upage = old_page_bound;
      while (upage < new_page_bound) {
        uint8_t* kpage = palloc_get_page(PAL_USER | PAL_ZERO);
        if (kpage == NULL || !pagedir_set_page(t->pagedir, upage, kpage, true)) {
          if (kpage != NULL)
            palloc_free_page(kpage);

          uint8_t* rollback_page = old_page_bound;
          while (rollback_page < upage) {
            void* frame = pagedir_get_page(t->pagedir, rollback_page);
            if (frame != NULL) {
              pagedir_clear_page(t->pagedir, rollback_page);
              palloc_free_page(frame);
            }
            rollback_page += PGSIZE;
          }
          return (void*)-1;
        }
        upage += PGSIZE;
      }
    }
  } else {
    if (new_page_bound < old_page_bound) {
      uint8_t* upage = new_page_bound;
      while (upage < old_page_bound) {
        void* frame = pagedir_get_page(t->pagedir, upage);
        if (frame != NULL) {
          pagedir_clear_page(t->pagedir, upage);
          palloc_free_page(frame);
        }
        upage += PGSIZE;
      }
    }
  }

  /* Only update heap_end if all allocations/deallocations succeeded */
  t->heap_end = new_break;
  return old_break;
}

static void syscall_handler(struct intr_frame* f) {
  uint32_t* args = (uint32_t*)f->esp;
  struct thread* t = thread_current();
  t->in_syscall = true;

  validate_buffer_in_user_region(args, sizeof(uint32_t));
  switch (args[0]) {
    case SYS_EXIT:
      validate_buffer_in_user_region(&args[1], sizeof(uint32_t));
      syscall_exit((int)args[1]);
      break;

    case SYS_OPEN:
      validate_buffer_in_user_region(&args[1], sizeof(uint32_t));
      validate_string_in_user_region((char*)args[1]);
      f->eax = (uint32_t)syscall_open((char*)args[1]);
      break;

    case SYS_WRITE:
      validate_buffer_in_user_region(&args[1], 3 * sizeof(uint32_t));
      validate_buffer_in_user_region((void*)args[2], (unsigned)args[3]);
      f->eax = (uint32_t)syscall_write((int)args[1], (void*)args[2], (unsigned)args[3]);
      break;

    case SYS_READ:
      validate_buffer_in_user_region(&args[1], 3 * sizeof(uint32_t));
      validate_buffer_in_user_region((void*)args[2], (unsigned)args[3]);
      f->eax = (uint32_t)syscall_read((int)args[1], (void*)args[2], (unsigned)args[3]);
      break;

    case SYS_CLOSE:
      validate_buffer_in_user_region(&args[1], sizeof(uint32_t));
      syscall_close((int)args[1]);
      break;

    case SYS_SBRK:
      validate_buffer_in_user_region(&args[1], sizeof(uint32_t));
      f->eax = (uint32_t)syscall_sbrk((intptr_t)args[1]);
      break;

    default:
      printf("Unimplemented system call: %d\n", (int)args[0]);
      break;
  }

  t->in_syscall = false;
}
