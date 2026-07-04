#include "devices/shutdown.h"
#include "filesys/filesys.h"
#include "threads/interrupt.h"
#include "threads/malloc.h"
#include "threads/synch.h"
#include "threads/thread.h"
#include "threads/vaddr.h"
#include "userprog/pagedir.h"
#include "userprog/process.h"
#include <stdio.h>
#include <stdlib.h>
#include <syscall-nr.h>

static void syscall_handler(struct intr_frame*);
static void check_valid_ptr(const void* vaddr);
static void check_valid_bytes(const void* vaddr, size_t size);
static size_t safe_strlen(const void* vaddr);
void exit_process(int status);

static struct lock filesys_lock;

void syscall_init(void) {
  intr_register_int(0x30, 3, INTR_ON, syscall_handler, "syscall");
  lock_init(&filesys_lock);
}

void exit_process(int status) {
  struct process* pcb = thread_current()->pcb;

  // 1. 打印 Pintos 测试系统强制要求的退出信息
  // printf("%s: exit(%d)\n", pcb->process_name, status);

  // 2. 如果我有父进程（my_status 不为 NULL），更新我的遗产
  if (pcb->my_status != NULL) {
    pcb->my_status->exit_status = status;
    pcb->my_status->is_alive = false;
    // 唤醒可能正在 wait 我的父进程
    sema_up(&pcb->my_status->wait_sema);
  }

  // 3. 将退出状态返回给内核并真正回收资源
  process_exit();
}

/* 检查指针是否有效。无效则直接处决进程。 */
static void check_valid_ptr(const void* vaddr) {
  if (vaddr == NULL || !is_user_vaddr(vaddr)) {
    exit_process(-1); // 自定义的退出逻辑，直接结束并返回 -1
  }
  // 检查是否在页表中分配了物理内存
  void* ptr = pagedir_get_page(thread_current()->pcb->pagedir, vaddr);
  if (ptr == NULL) {
    exit_process(-1);
  }
}

static void check_valid_bytes(const void* vaddr, size_t size) {
  for (size_t i = 0; i < size; i++) {
    check_valid_ptr((const uint8_t*)vaddr + i);
  }
}

/* Safely determine the length of a user-space string by validating
   each byte before reading it. Avoids kernel page fault if the
   string spans into unmapped memory. */
static size_t safe_strlen(const void* vaddr) {
  size_t len = 0;
  const char* p = (const char*)vaddr;
  while (true) {
    check_valid_ptr(p);
    if (*p == '\0')
      return len;
    p++;
    len++;
  }
}

static void syscall_handler(struct intr_frame* f UNUSED) {
  check_valid_bytes(f->esp, sizeof(uint32_t));
  uint32_t* args = ((uint32_t*)f->esp);

  /*
   * The following print statement, if uncommented, will print out the syscall
   * number whenever a process enters a system call. You might find it useful
   * when debugging. It will cause tests to fail, however, so you should not
   * include it in your final submission.
   */

  /* printf("System call number: %d\n", args[0]); */

  switch (args[0]) {
    case SYS_EXIT: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      f->eax = args[1];
      exit_process((int)args[1]);
      break;
    }
    case SYS_WRITE: {
      check_valid_bytes(args, 4 * sizeof(uint32_t));
      int fd = (int)args[1];
      const void* buffer = (const void*)args[2];
      unsigned size = (unsigned)args[3];

      if (fd == 1) {
        check_valid_bytes(buffer, size);
        putbuf(buffer, size);
        f->eax = size;
      } else {
        lock_acquire(&filesys_lock);
        struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
        if (file_ptr == NULL) {
          lock_release(&filesys_lock);
          f->eax = -1;
        } else {
          check_valid_bytes(buffer, size);
          int n = file_write(file_ptr, buffer, size);
          lock_release(&filesys_lock);
          f->eax = n;
        }
      }
      break;
    }
    case SYS_PRACTICE: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      f->eax = args[1] + 1;
      break;
    }
    case SYS_HALT: {
      shutdown_power_off();
      break;
    }
    case SYS_EXEC: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      const char* cmd_line = (const char*)args[1];
      check_valid_bytes(cmd_line, safe_strlen(cmd_line) + 1);
      pid_t child_pid = process_execute(cmd_line);

      if (child_pid == TID_ERROR) {
        f->eax = -1;
      } else {
        struct child_status* child_status = get_child_by_pid(child_pid);
        sema_down(&child_status->load_sema);
        if (!child_status->load_success) {
          f->eax = -1;
        } else {
          f->eax = child_pid;
        }
      }
      break;
    }
    case SYS_WAIT: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      struct child_status* child_status = get_child_by_pid((pid_t)args[1]);

      if (child_status == NULL) {
        f->eax = -1;
        break;
      }
      if (child_status->is_waited) {
        f->eax = -1;
        break;
      }

      if (child_status->is_alive) {
        sema_down(&child_status->wait_sema);
      }

      child_status->is_waited = true;
      f->eax = child_status->exit_status;
      list_remove(&child_status->elem);
      free(child_status);
      break;
    }
    case SYS_FORK: {
      f->eax = process_fork(f);
      break;
    }
    case SYS_CREATE: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      const char* file = (const char*)args[1];
      unsigned initial_size = (unsigned)args[2];
      check_valid_bytes(file, safe_strlen(file) + 1);
      lock_acquire(&filesys_lock);
      f->eax = filesys_create(file, initial_size);
      lock_release(&filesys_lock);
      break;
    }
    case SYS_REMOVE: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      const char* file = (const char*)args[1];
      check_valid_bytes(file, safe_strlen(file) + 1);
      lock_acquire(&filesys_lock);
      f->eax = filesys_remove(file);
      lock_release(&filesys_lock);
      break;
    }
    case SYS_OPEN: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      const char* file = (const char*)args[1];
      check_valid_bytes(file, safe_strlen(file) + 1);
      lock_acquire(&filesys_lock);
      struct file* file_ptr = filesys_open(file);
      if (file_ptr == NULL) {
        lock_release(&filesys_lock);
        f->eax = -1;
      } else {
        int result = store_fd(thread_current()->pcb, file_ptr, -1);
        lock_release(&filesys_lock);
        f->eax = result;
      }
      break;
    }
    case SYS_FILESIZE: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      int fd = (int)args[1];
      lock_acquire(&filesys_lock);
      struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
      if (file_ptr == NULL) {
        lock_release(&filesys_lock);
        f->eax = -1;
      } else {
        off_t sz = file_length(file_ptr);
        lock_release(&filesys_lock);
        f->eax = sz;
      }
      break;
    }
    case SYS_READ: {
      check_valid_bytes(args, 4 * sizeof(uint32_t));
      int fd = (int)args[1];
      void* buffer = (void*)args[2];
      unsigned size = (unsigned)args[3];
      check_valid_bytes(buffer, size);
      lock_acquire(&filesys_lock);
      struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
      if (file_ptr == NULL) {
        lock_release(&filesys_lock);
        f->eax = -1;
      } else {
        int n = file_read(file_ptr, buffer, size);
        lock_release(&filesys_lock);
        f->eax = n;
      }
      break;
    }
    case SYS_SEEK: {
      check_valid_bytes(args, 3 * sizeof(uint32_t));
      int fd = (int)args[1];
      unsigned position = (unsigned)args[2];
      lock_acquire(&filesys_lock);
      struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
      if (file_ptr != NULL) {
        file_seek(file_ptr, position);
      }
      lock_release(&filesys_lock);
      break;
    }
    case SYS_TELL: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      int fd = (int)args[1];
      lock_acquire(&filesys_lock);
      struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
      if (file_ptr == NULL) {
        lock_release(&filesys_lock);
        f->eax = -1;
      } else {
        off_t pos = file_tell(file_ptr);
        lock_release(&filesys_lock);
        f->eax = pos;
      }
      break;
    }
    case SYS_CLOSE: {
      check_valid_bytes(args, 2 * sizeof(uint32_t));
      int fd = (int)args[1];
      struct process* pcb = thread_current()->pcb;
      lock_acquire(&filesys_lock);
      struct file* file_ptr = (struct file*)get_kernel_fd(pcb, fd);
      /* Skip file_close for inherited fds to avoid double-close on shared struct file */
      if (file_ptr != NULL) {
        bool inherited =
            (fd >= 0 && fd < 128 && pcb->fd_table != NULL && pcb->fd_table->inherited[fd]);
        if (!inherited)
          file_close(file_ptr);
      }
      remove_fd(pcb, fd);
      lock_release(&filesys_lock);
      break;
    }
    case SYS_PT_CREATE: {
      check_valid_bytes(args, 4 * sizeof(uint32_t));
      stub_fun sfun = (stub_fun)args[1];
      pthread_fun tfun = (pthread_fun)args[2];
      const void* arg = (const void*)args[3];
      check_valid_ptr(sfun);
      check_valid_ptr(tfun);
      f->eax = pthread_execute(sfun, tfun, (void*)arg);
      break;
    }
    case SYS_PT_EXIT: {
      pthread_exit();
      break;
    }
    case SYS_PT_JOIN: {
      check_valid_bytes(args, sizeof(tid_t));
      f->eax = pthread_join((tid_t)args[1]);
      break;
    }
    default: {
      printf("Unimplemented system call: %d\n", (int)args[0]);
      break;
    }
  }
}
