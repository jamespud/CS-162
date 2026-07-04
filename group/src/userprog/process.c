#include "userprog/process.h"
#include "filesys/directory.h"
#include "filesys/file.h"
#include "filesys/filesys.h"
#include "threads/flags.h"
#include "threads/init.h"
#include "threads/interrupt.h"
#include "threads/malloc.h"
#include "threads/palloc.h"
#include "threads/pte.h"
#include "threads/synch.h"
#include "threads/thread.h"
#include "threads/vaddr.h"
#include "userprog/gdt.h"
#include "userprog/pagedir.h"
#include "userprog/tss.h"
#include <debug.h>
#include <inttypes.h>
#include <round.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static thread_func start_process NO_RETURN;
static thread_func start_pthread NO_RETURN;
static bool load(const char* file_name, void (**eip)(void), void** esp);
bool setup_thread(stub_fun sfun, pthread_fun tfun, void* arg, void (**eip)(void), void** esp);

struct exec_args {
  char* file_name;
  struct child_status* my_status;
};

struct fork_args {
  struct intr_frame parent_frame; // 复制父进程的寄存器状态（必须传值！）
  uint32_t* child_pagedir;        // 子进程的新页目录
  struct child_status* my_status; // 指向父进程 children 列表中的条目
  struct fd_table* fd_table;      // 文件描述符表
  struct file* parent_exec_file;  // 父进程的可执行文件句柄
};

typedef struct pthread_arg {
  stub_fun sfun;
  pthread_fun tfun;
  void* arg;
  struct thread_status_node* status_node;
  struct process* pcb;
} pthread_arg_t;

void status_node_init(struct thread_status_node* tsn) {
  tsn->tid = TID_ERROR;
  tsn->is_exited = false;
  tsn->is_joined = false;
  sema_init(&tsn->join_sema, 0);
}

/* Initializes user programs in the system by ensuring the main
   thread has a minimal PCB so that it can execute and wait for
   the first user process. Any additions to the PCB should be also
   initialized here if main needs those members */
void userprog_init(void) {
  struct thread* t = thread_current();
  bool success;

  /* Allocate process control block
     It is imoprtant that this is a call to calloc and not malloc,
     so that t->pcb->pagedir is guaranteed to be NULL (the kernel's
     page directory) when t->pcb is assigned, because a timer interrupt
     can come at any time and activate our pagedir */
  t->pcb = calloc(sizeof(struct process), 1);
  success = t->pcb != NULL;

  /* Kill the kernel if we did not succeed */
  ASSERT(success);

  t->pcb->fd_table = malloc(sizeof(struct fd_table));
  success = t->pcb->fd_table != NULL;
  ASSERT(success);

  for (int i = 0; i < 128; i++)
    t->pcb->fd_table->entries[i] = NULL;
  for (int i = 0; i < 128; i++)
    t->pcb->fd_table->inherited[i] = false;
  t->pcb->fd_table->next_fd = 2;

  list_init(&t->pcb->children);
  list_init(&t->pcb->thread_statuses);
  t->pcb->my_status = NULL;
}

/* Starts a new thread running a user program loaded from
   FILENAME.  The new thread may be scheduled (and may even exit)
   before process_execute() returns.  Returns the new process's
   process id, or TID_ERROR if the thread cannot be created. */
pid_t process_execute(const char* file_name) {
  char* fn_copy;
  tid_t tid;

  /* Make a copy of FILE_NAME.
     Otherwise there's a race between the caller and load(). */
  fn_copy = palloc_get_page(0);
  if (fn_copy == NULL)
    return TID_ERROR;
  strlcpy(fn_copy, file_name, PGSIZE);

  struct child_status* my_status = malloc(sizeof(struct child_status));

  if (my_status == NULL) {
    palloc_free_page(fn_copy);
    return TID_ERROR;
  }

  my_status->pid = TID_ERROR;
  my_status->is_alive = true;
  my_status->is_waited = false;
  my_status->exit_status = -1;
  my_status->load_success = false;
  sema_init(&my_status->wait_sema, 0);
  sema_init(&my_status->load_sema, 0);

  struct exec_args* args = malloc(sizeof(struct exec_args));
  if (args == NULL) {
    palloc_free_page(fn_copy);
    free(my_status);
    return TID_ERROR;
  }

  args->file_name = fn_copy;
  args->my_status = my_status;

  list_push_back(&thread_current()->pcb->children, &my_status->elem);

  /* Create a new thread to execute FILE_NAME. */
  tid = thread_create(file_name, PRI_DEFAULT, start_process, args);

  if (tid == TID_ERROR) {
    palloc_free_page(fn_copy);
    list_remove(&my_status->elem);
    free(my_status);
    free(args);
  }

  my_status->pid = tid;
  return tid;
}

/* A thread function that loads a user process and starts it
   running. */
static void start_process(void* args_) {
  struct exec_args* args = (struct exec_args*)args_;
  char* file_name = args->file_name;
  struct child_status* my_status = args->my_status;
  struct thread* t = thread_current();
  struct intr_frame if_;
  bool success, pcb_success;

  /* Allocate process control block */
  struct process* new_pcb = malloc(sizeof(struct process));
  success = pcb_success = new_pcb != NULL;

  struct thread_status_node* tsn = malloc(sizeof(struct thread_status_node));
  success &= tsn != NULL;

  /* Initialize process control block */
  if (success) {
    // Ensure that timer_interrupt() -> schedule() -> process_activate()
    // does not try to activate our uninitialized pagedir
    new_pcb->pagedir = NULL;
    t->pcb = new_pcb;

    t->pcb->my_status = my_status;
    list_init(&new_pcb->children);
    list_init(&new_pcb->thread_statuses);
    memset(new_pcb->user_locks, 0, sizeof(new_pcb->user_locks));
    memset(new_pcb->user_semas, 0, sizeof(new_pcb->user_semas));

    status_node_init(tsn);
    t->status_node = tsn;
    tsn->tid = t->tid;

    list_push_back(&new_pcb->thread_statuses, &tsn->elem);

    // Continue initializing the PCB as normal
    t->pcb->main_thread = t;
  }

  struct fd_table* fd_table = malloc(sizeof(struct fd_table));
  if (fd_table != NULL) {
    for (int i = 0; i < 128; i++) {
      fd_table->entries[i] = NULL;
      fd_table->inherited[i] = false;
    }
    fd_table->next_fd = 2;
  }
  t->pcb->fd_table = fd_table;

  const char delim[] = " ";
  char *token, *save_ptr;
  token = strtok_r(file_name, delim, &save_ptr);

  size_t argc = 1;
  char* argv[128];
  argv[0] = token;

  while ((token = strtok_r(NULL, delim, &save_ptr)) != NULL) {
    if (argc >= 128)
      break; // 防御性编程：防止越界
    argv[argc] = token;
    argc++;
  }
  argv[argc] = NULL;

  /* Set process name from program name (not full command line) */
  if (success)
    strlcpy(t->pcb->process_name, argv[0], sizeof t->pcb->process_name);

  /* Initialize interrupt frame and load executable. */
  if (success) {
    memset(&if_, 0, sizeof if_);
    if_.gs = if_.fs = if_.es = if_.ds = if_.ss = SEL_UDSEG;
    if_.cs = SEL_UCSEG;
    if_.eflags = FLAG_IF | FLAG_MBS;
    success = load(argv[0], &if_.eip, &if_.esp);
  }

  t->pcb->my_status->load_success = success;
  sema_up(&t->pcb->my_status->load_sema);

  /* Keep executable write-denied for ROX protection (best-effort) */
  if (success) {
    struct file* exec = filesys_open(argv[0]);
    if (exec != NULL) {
      file_deny_write(exec);
      t->pcb->exec_file = exec;
    }
  }

  if (success) {
    /* Push arguments onto the stack */
    for (int i = argc - 1; i >= 0; i--) {
      size_t arg_len = strlen(argv[i]) + 1;
      if_.esp -= arg_len;
      memcpy(if_.esp, argv[i], arg_len);
      argv[i] = if_.esp;
    }

    /* Pad so the final %esp (after sentinel pushes) is at offset 12,
       matching the expected alignment when _start calls main() */
    size_t pad = ((uintptr_t)if_.esp - (argc + 4) * sizeof(uint32_t) - 12) & 0xf;
    if_.esp -= pad;
    memset(if_.esp, 0, pad);

    if_.esp -= sizeof(char*);
    *(char**)if_.esp = NULL;

    for (int i = argc - 1; i >= 0; i--) {
      if_.esp -= sizeof(char*);
      *(char**)if_.esp = argv[i];
    }

    char** argv_address = if_.esp;
    if_.esp -= sizeof(char**);
    *(char***)if_.esp = argv_address;

    if_.esp -= sizeof(int);
    *(int*)if_.esp = argc;

    if_.esp -= sizeof(void*);
    *(void**)if_.esp = NULL;

    // hex_dump((uintptr_t)if_.esp, if_.esp, PHYS_BASE - if_.esp, true);
  }

  /* Handle failure with succesful PCB malloc. Must free the PCB */
  if (!success && pcb_success) {
    // Avoid race where PCB is freed before t->pcb is set to NULL
    // If this happens, then an unfortuantely timed timer interrupt
    // can try to activate the pagedir, but it is now freed memory
    struct process* pcb_to_free = t->pcb;
    t->pcb = NULL;
    free(pcb_to_free);
  }

  /* Clean up. Exit on failure or jump to userspace */
  free(args);
  palloc_free_page(file_name);
  if (!success) {
    my_status->exit_status = -1;
    my_status->is_alive = false;
    sema_up(&my_status->wait_sema);
    thread_exit();
  }

  /* Start the user process by simulating a return from an
     interrupt, implemented by intr_exit (in
     threads/intr-stubs.S).  Because intr_exit takes all of its
     arguments on the stack in the form of a `struct intr_frame',
     we just point the stack pointer (%esp) to our stack frame
     and jump to it. */
  asm volatile("movl %0, %%esp; jmp intr_exit" : : "g"(&if_) : "memory");
  NOT_REACHED();
}

static void start_fork(void* args_);

pid_t process_fork(struct intr_frame* f) {
  struct thread* cur = thread_current();
  uint32_t* child_pd;
  struct child_status* my_status;
  struct fork_args* fargs;
  tid_t tid;

  /* 1. 为子进程创建 child_status */
  my_status = malloc(sizeof(struct child_status));
  if (my_status == NULL)
    return TID_ERROR;

  my_status->pid = TID_ERROR;
  my_status->is_alive = true;
  my_status->is_waited = false;
  my_status->exit_status = -1;
  my_status->load_success = true; // fork 不需要 load，直接设为 true
  sema_init(&my_status->wait_sema, 0);
  sema_init(&my_status->load_sema, 0);
  list_push_back(&cur->pcb->children, &my_status->elem);

  /* 2. 为新进程创建页目录 */
  child_pd = palloc_get_page(0);
  if (child_pd == NULL) {
    list_remove(&my_status->elem);
    free(my_status);
    return TID_ERROR;
  }
  memcpy(child_pd, init_page_dir, PGSIZE); // 复制内核映射部分

  /* 3. 遍历父进程所有用户页，复制到子进程 */
  void* upage;
  for (upage = 0; (uintptr_t)upage < (uintptr_t)PHYS_BASE; upage += PGSIZE) {
    void* kpage = pagedir_get_page(cur->pcb->pagedir, upage);
    if (kpage == NULL)
      continue; // 此页未映射，跳过

    /* 分配新物理页并复制内容 */
    void* new_page = palloc_get_page(PAL_USER);
    if (new_page == NULL) {
      /* 清理：释放已分配的所有页 */
      pagedir_destroy(child_pd); // 会自动释放所有已映射的页
      list_remove(&my_status->elem);
      free(my_status);
      return TID_ERROR;
    }
    memcpy(new_page, kpage, PGSIZE);

    /* 判断父进程中此页是否可写 */
    uint32_t* pde = cur->pcb->pagedir + pd_no(upage);
    uint32_t* pt = pde_get_pt(*pde);
    uint32_t* pte = &pt[pt_no(upage)];
    bool writable = (*pte & PTE_W) != 0;

    /* 映射到子进程页目录 */
    if (!pagedir_set_page(child_pd, upage, new_page, writable)) {
      palloc_free_page(new_page);
      pagedir_destroy(child_pd);
      list_remove(&my_status->elem);
      free(my_status);
      return TID_ERROR;
    }
  }

  /* 4. 创建 fork_args 传给子线程 */
  fargs = malloc(sizeof(struct fork_args));
  if (fargs == NULL) {
    pagedir_destroy(child_pd);
    list_remove(&my_status->elem);
    free(my_status);
    return TID_ERROR;
  }

  fargs->parent_frame = *f; // 拷贝整个 intr_frame！（不是存指针）
  fargs->child_pagedir = child_pd;
  fargs->my_status = my_status;
  fargs->fd_table = cur->pcb->fd_table; // 共享父进程的文件描述符表
  fargs->parent_exec_file = cur->pcb->exec_file;

  /* 5. 创建子线程 */
  tid = thread_create(cur->pcb->process_name, PRI_DEFAULT, start_fork, fargs);
  if (tid == TID_ERROR) {
    pagedir_destroy(child_pd);
    free(fargs);
    list_remove(&my_status->elem);
    free(my_status);
    return TID_ERROR;
  }

  my_status->pid = tid;

  /* 6. fork 不需要等待子进程加载——子进程直接从当前状态继续 */
  // load_sema 已经初始化为 0，但子线程 start_fork 不需要 signal 它
  // 因为 fork() 直接返回，不需要 exec 那样的加载等待
  // 直接 sema_up，让可能的等待者立即通过
  sema_up(&my_status->load_sema);

  return tid;
}

/* 子进程线程入口 */
static void start_fork(void* args_) {
  struct fork_args* fargs = (struct fork_args*)args_;
  struct intr_frame child_if;
  struct thread* t = thread_current();
  struct process* new_pcb;

  /* 分配并初始化子进程 PCB */
  new_pcb = malloc(sizeof(struct process));
  if (new_pcb == NULL) {
    pagedir_destroy(fargs->child_pagedir);
    free(fargs);
    // 通知父进程我们 failed
    thread_exit();
  }

  /* Copy parent's fd_table: same struct file pointers (shared positions) */
  struct fd_table* child_fd = malloc(sizeof(struct fd_table));
  if (child_fd != NULL) {
    memcpy(child_fd, fargs->fd_table, sizeof(struct fd_table));
    for (int i = 0; i < 128; i++)
      if (child_fd->entries[i] != NULL)
        child_fd->inherited[i] = true;
  }

  new_pcb->pagedir = fargs->child_pagedir;
  new_pcb->fd_table = child_fd;
  new_pcb->main_thread = t;
  list_init(&new_pcb->children);
  list_init(&new_pcb->thread_statuses);

  /* Child gets its own exec_file handle (independent deny_write refcounting) */
  if (fargs->parent_exec_file != NULL)
    new_pcb->exec_file = file_reopen(fargs->parent_exec_file);
  else
    new_pcb->exec_file = NULL;

  t->pcb = new_pcb;
  t->pcb->my_status = fargs->my_status;
  strlcpy(t->pcb->process_name, thread_current()->name, sizeof t->pcb->process_name);

  /* 复制父进程的寄存器状态 */
  child_if = fargs->parent_frame;

  /* fork 在子进程中返回 0 */
  child_if.eax = 0;

  /* 释放 fork_args（不再需要） */
  free(fargs);

  /* 激活子进程的页目录 */
  process_activate();

  /* 跳入用户空间 */
  asm volatile("movl %0, %%esp; jmp intr_exit" : : "g"(&child_if) : "memory");
  NOT_REACHED();
}

/* Waits for process with PID child_pid to die and returns its exit status.
   If it was terminated by the kernel (i.e. killed due to an
   exception), returns -1.  If child_pid is invalid or if it was not a
   child of the calling process, or if process_wait() has already
   been successfully called for the given PID, returns -1
   immediately, without waiting.

   This function will be implemented in problem 2-2.  For now, it
   does nothing. */
int process_wait(pid_t child_pid) {
  struct child_status* cs = get_child_by_pid(child_pid);
  if (cs == NULL)
    return -1;

  if (cs->is_alive)
    sema_down(&cs->wait_sema);

  int status = cs->exit_status;
  list_remove(&cs->elem);
  free(cs);
  return status;
}

/* Free the current process's resources. */
void process_exit(void) {
  struct thread* cur = thread_current();
  uint32_t* pd;

  /* If this thread does not have a PCB, don't worry */
  if (cur->pcb == NULL) {
    thread_exit();
    NOT_REACHED();
  }

  if (cur->pcb->my_status != NULL)
    printf("%s: exit(%d)\n", cur->pcb->process_name, cur->pcb->my_status->exit_status);

  struct list_elem* e;
  for (e = list_begin(&cur->pcb->children); e != list_end(&cur->pcb->children);) {
    struct child_status* child_status = list_entry(e, struct child_status, elem);
    e = list_next(e);
    if (!child_status->is_alive) {
      list_remove(&child_status->elem);
      free(child_status);
    }
  }

  for (e = list_begin(&cur->pcb->thread_statuses); e != list_end(&cur->pcb->thread_statuses);) {
    struct thread_status_node* tsn = list_entry(e, struct thread_status_node, elem);
    e = list_next(e);
    list_remove(&tsn->elem);
    free(tsn);
  }

  for (size_t i = 0; i < USER_LOCK_SIZE; i++) {
    if (cur->pcb->user_locks[i] != NULL) {
      free(cur->pcb->user_locks[i]);
    }
  }
  for (size_t i = 0; i < USER_SEMA_SIZE; i++) {
    if (cur->pcb->user_semas[i] != NULL) {
      free(cur->pcb->user_semas[i]);
    }
  }

  if (cur->pcb->exec_file != NULL)
    file_close(cur->pcb->exec_file);

  if (cur->pcb->fd_table != NULL) {
    for (int i = 0; i < 128; i++) {
      if (cur->pcb->fd_table->entries[i] != NULL && !cur->pcb->fd_table->inherited[i]) {
        file_close(cur->pcb->fd_table->entries[i]);
      }
    }
    free(cur->pcb->fd_table);
  }

  /* Destroy the current process's page directory and switch back
     to the kernel-only page directory. */
  pd = cur->pcb->pagedir;
  if (pd != NULL) {
    /* Correct ordering here is crucial.  We must set
         cur->pcb->pagedir to NULL before switching page directories,
         so that a timer interrupt can't switch back to the
         process page directory.  We must activate the base page
         directory before destroying the process's page
         directory, or our active page directory will be one
         that's been freed (and cleared). */
    cur->pcb->pagedir = NULL;
    pagedir_activate(NULL);
    pagedir_destroy(pd);
  }

  /* Free the PCB of this process and kill this thread
     Avoid race where PCB is freed before t->pcb is set to NULL
     If this happens, then an unfortuantely timed timer interrupt
     can try to activate the pagedir, but it is now freed memory */
  struct process* pcb_to_free = cur->pcb;
  cur->pcb = NULL;
  free(pcb_to_free);

  thread_exit();
}

/* Sets up the CPU for running user code in the current
   thread. This function is called on every context switch. */
void process_activate(void) {
  struct thread* t = thread_current();

  /* Activate thread's page tables. */
  if (t->pcb != NULL && t->pcb->pagedir != NULL)
    pagedir_activate(t->pcb->pagedir);
  else
    pagedir_activate(NULL);

  /* Set thread's kernel stack for use in processing interrupts.
     This does nothing if this is not a user process. */
  tss_update();
}

/* We load ELF binaries.  The following definitions are taken
   from the ELF specification, [ELF1], more-or-less verbatim.  */

/* ELF types.  See [ELF1] 1-2. */
typedef uint32_t Elf32_Word, Elf32_Addr, Elf32_Off;
typedef uint16_t Elf32_Half;

/* For use with ELF types in printf(). */
#define PE32Wx PRIx32 /* Print Elf32_Word in hexadecimal. */
#define PE32Ax PRIx32 /* Print Elf32_Addr in hexadecimal. */
#define PE32Ox PRIx32 /* Print Elf32_Off in hexadecimal. */
#define PE32Hx PRIx16 /* Print Elf32_Half in hexadecimal. */

/* Executable header.  See [ELF1] 1-4 to 1-8.
   This appears at the very beginning of an ELF binary. */
struct Elf32_Ehdr {
  unsigned char e_ident[16];
  Elf32_Half e_type;
  Elf32_Half e_machine;
  Elf32_Word e_version;
  Elf32_Addr e_entry;
  Elf32_Off e_phoff;
  Elf32_Off e_shoff;
  Elf32_Word e_flags;
  Elf32_Half e_ehsize;
  Elf32_Half e_phentsize;
  Elf32_Half e_phnum;
  Elf32_Half e_shentsize;
  Elf32_Half e_shnum;
  Elf32_Half e_shstrndx;
};

/* Program header.  See [ELF1] 2-2 to 2-4.
   There are e_phnum of these, starting at file offset e_phoff
   (see [ELF1] 1-6). */
struct Elf32_Phdr {
  Elf32_Word p_type;
  Elf32_Off p_offset;
  Elf32_Addr p_vaddr;
  Elf32_Addr p_paddr;
  Elf32_Word p_filesz;
  Elf32_Word p_memsz;
  Elf32_Word p_flags;
  Elf32_Word p_align;
};

/* Values for p_type.  See [ELF1] 2-3. */
#define PT_NULL 0           /* Ignore. */
#define PT_LOAD 1           /* Loadable segment. */
#define PT_DYNAMIC 2        /* Dynamic linking info. */
#define PT_INTERP 3         /* Name of dynamic loader. */
#define PT_NOTE 4           /* Auxiliary info. */
#define PT_SHLIB 5          /* Reserved. */
#define PT_PHDR 6           /* Program header table. */
#define PT_STACK 0x6474e551 /* Stack segment. */

/* Flags for p_flags.  See [ELF3] 2-3 and 2-4. */
#define PF_X 1 /* Executable. */
#define PF_W 2 /* Writable. */
#define PF_R 4 /* Readable. */

static bool setup_stack(void** esp);
static bool validate_segment(const struct Elf32_Phdr*, struct file*);
static bool load_segment(struct file* file, off_t ofs, uint8_t* upage, uint32_t read_bytes,
                         uint32_t zero_bytes, bool writable);

/* Loads an ELF executable from FILE_NAME into the current thread.
   Stores the executable's entry point into *EIP
   and its initial stack pointer into *ESP.
   Returns true if successful, false otherwise. */
bool load(const char* file_name, void (**eip)(void), void** esp) {
  struct thread* t = thread_current();
  struct Elf32_Ehdr ehdr;
  struct file* file = NULL;
  off_t file_ofs;
  bool success = false;
  int i;

  /* Allocate and activate page directory. */
  t->pcb->pagedir = pagedir_create();
  if (t->pcb->pagedir == NULL)
    goto done;
  process_activate();

  /* Open executable file. */
  file = filesys_open(file_name);
  if (file == NULL) {
    printf("load: %s: open failed\n", file_name);
    goto done;
  }

  /* Read and verify executable header. */
  if (file_read(file, &ehdr, sizeof ehdr) != sizeof ehdr ||
      memcmp(ehdr.e_ident, "\177ELF\1\1\1", 7) || ehdr.e_type != 2 || ehdr.e_machine != 3 ||
      ehdr.e_version != 1 || ehdr.e_phentsize != sizeof(struct Elf32_Phdr) || ehdr.e_phnum > 1024) {
    printf("load: %s: error loading executable\n", file_name);
    goto done;
  }

  /* Read program headers. */
  file_ofs = ehdr.e_phoff;
  for (i = 0; i < ehdr.e_phnum; i++) {
    struct Elf32_Phdr phdr;

    if (file_ofs < 0 || file_ofs > file_length(file))
      goto done;
    file_seek(file, file_ofs);

    if (file_read(file, &phdr, sizeof phdr) != sizeof phdr)
      goto done;
    file_ofs += sizeof phdr;
    switch (phdr.p_type) {
      case PT_NULL:
      case PT_NOTE:
      case PT_PHDR:
      case PT_STACK:
      default:
        /* Ignore this segment. */
        break;
      case PT_DYNAMIC:
      case PT_INTERP:
      case PT_SHLIB:
        goto done;
      case PT_LOAD:
        if (validate_segment(&phdr, file)) {
          bool writable = (phdr.p_flags & PF_W) != 0;
          uint32_t file_page = phdr.p_offset & ~PGMASK;
          uint32_t mem_page = phdr.p_vaddr & ~PGMASK;
          uint32_t page_offset = phdr.p_vaddr & PGMASK;
          uint32_t read_bytes, zero_bytes;
          if (phdr.p_filesz > 0) {
            /* Normal segment.
                     Read initial part from disk and zero the rest. */
            read_bytes = page_offset + phdr.p_filesz;
            zero_bytes = (ROUND_UP(page_offset + phdr.p_memsz, PGSIZE) - read_bytes);
          } else {
            /* Entirely zero.
                     Don't read anything from disk. */
            read_bytes = 0;
            zero_bytes = ROUND_UP(page_offset + phdr.p_memsz, PGSIZE);
          }
          if (!load_segment(file, file_page, (void*)mem_page, read_bytes, zero_bytes, writable))
            goto done;
        } else
          goto done;
        break;
    }
  }

  /* Set up stack. */
  if (!setup_stack(esp))
    goto done;

  /* Start address. */
  *eip = (void (*)(void))ehdr.e_entry;

  success = true;

done:
  /* We arrive here whether the load is successful or not. */
  file_close(file);
  return success;
}

/* load() helpers. */

static bool install_page(void* upage, void* kpage, bool writable);

/* Checks whether PHDR describes a valid, loadable segment in
   FILE and returns true if so, false otherwise. */
static bool validate_segment(const struct Elf32_Phdr* phdr, struct file* file) {
  /* p_offset and p_vaddr must have the same page offset. */
  if ((phdr->p_offset & PGMASK) != (phdr->p_vaddr & PGMASK))
    return false;

  /* p_offset must point within FILE. */
  if (phdr->p_offset > (Elf32_Off)file_length(file))
    return false;

  /* p_memsz must be at least as big as p_filesz. */
  if (phdr->p_memsz < phdr->p_filesz)
    return false;

  /* The segment must not be empty. */
  if (phdr->p_memsz == 0)
    return false;

  /* The virtual memory region must both start and end within the
     user address space range. */
  if (!is_user_vaddr((void*)phdr->p_vaddr))
    return false;
  if (!is_user_vaddr((void*)(phdr->p_vaddr + phdr->p_memsz)))
    return false;

  /* The region cannot "wrap around" across the kernel virtual
     address space. */
  if (phdr->p_vaddr + phdr->p_memsz < phdr->p_vaddr)
    return false;

  /* Disallow mapping page 0.
     Not only is it a bad idea to map page 0, but if we allowed
     it then user code that passed a null pointer to system calls
     could quite likely panic the kernel by way of null pointer
     assertions in memcpy(), etc. */
  if (phdr->p_vaddr < PGSIZE)
    return false;

  /* It's okay. */
  return true;
}

/* Loads a segment starting at offset OFS in FILE at address
   UPAGE.  In total, READ_BYTES + ZERO_BYTES bytes of virtual
   memory are initialized, as follows:

        - READ_BYTES bytes at UPAGE must be read from FILE
          starting at offset OFS.

        - ZERO_BYTES bytes at UPAGE + READ_BYTES must be zeroed.

   The pages initialized by this function must be writable by the
   user process if WRITABLE is true, read-only otherwise.

   Return true if successful, false if a memory allocation error
   or disk read error occurs. */
static bool load_segment(struct file* file, off_t ofs, uint8_t* upage, uint32_t read_bytes,
                         uint32_t zero_bytes, bool writable) {
  ASSERT((read_bytes + zero_bytes) % PGSIZE == 0);
  ASSERT(pg_ofs(upage) == 0);
  ASSERT(ofs % PGSIZE == 0);

  file_seek(file, ofs);
  while (read_bytes > 0 || zero_bytes > 0) {
    /* Calculate how to fill this page.
         We will read PAGE_READ_BYTES bytes from FILE
         and zero the final PAGE_ZERO_BYTES bytes. */
    size_t page_read_bytes = read_bytes < PGSIZE ? read_bytes : PGSIZE;
    size_t page_zero_bytes = PGSIZE - page_read_bytes;

    /* Get a page of memory. */
    uint8_t* kpage = palloc_get_page(PAL_USER);
    if (kpage == NULL)
      return false;

    /* Load this page. */
    if (file_read(file, kpage, page_read_bytes) != (int)page_read_bytes) {
      palloc_free_page(kpage);
      return false;
    }
    memset(kpage + page_read_bytes, 0, page_zero_bytes);

    /* Add the page to the process's address space. */
    if (!install_page(upage, kpage, writable)) {
      palloc_free_page(kpage);
      return false;
    }

    /* Advance. */
    read_bytes -= page_read_bytes;
    zero_bytes -= page_zero_bytes;
    upage += PGSIZE;
  }
  return true;
}

/* Create a minimal stack by mapping a zeroed page at the top of
   user virtual memory. */
static bool setup_stack(void** esp) {
  uint8_t* kpage;
  bool success = false;

  kpage = palloc_get_page(PAL_USER | PAL_ZERO);
  if (kpage != NULL) {
    success = install_page(((uint8_t*)PHYS_BASE) - PGSIZE, kpage, true);
    if (success)
      *esp = PHYS_BASE;
    else
      palloc_free_page(kpage);
  }
  return success;
}

static bool setup_pthread_stack(void** esp, void* base, size_t offset) {
  uint8_t* kpage;
  bool success = false;

  kpage = palloc_get_page(PAL_USER | PAL_ZERO);
  if (kpage != NULL) {
    success = install_page(base - offset, kpage, true);
    if (success)
      *esp = (uint8_t*)base - (uintptr_t)offset + PGSIZE;
    else
      palloc_free_page(kpage);
  }
  return success;
}

/* Adds a mapping from user virtual address UPAGE to kernel
   virtual address KPAGE to the page table.
   If WRITABLE is true, the user process may modify the page;
   otherwise, it is read-only.
   UPAGE must not already be mapped.
   KPAGE should probably be a page obtained from the user pool
   with palloc_get_page().
   Returns true on success, false if UPAGE is already mapped or
   if memory allocation fails. */
static bool install_page(void* upage, void* kpage, bool writable) {
  struct thread* t = thread_current();

  /* Verify that there's not already a page at that virtual
     address, then map our page there. */
  return (pagedir_get_page(t->pcb->pagedir, upage) == NULL &&
          pagedir_set_page(t->pcb->pagedir, upage, kpage, writable));
}

/* Returns true if t is the main thread of the process p */
bool is_main_thread(struct thread* t, struct process* p) { return p->main_thread == t; }

/* Gets the PID of a process */
pid_t get_pid(struct process* p) { return (pid_t)p->main_thread->tid; }

/* Creates a new stack for the thread and sets up its arguments.
   Stores the thread's entry point into *EIP and its initial stack
   pointer into *ESP. Handles all cleanup if unsuccessful. Returns
   true if successful, false otherwise.

   This function will be implemented in Project 2: Multithreading. For
   now, it does nothing. You may find it necessary to change the
   function signature. */
bool setup_thread(stub_fun sfun, pthread_fun tfun, void* arg, void (**eip)(void), void** esp) {
  struct thread* t = thread_current();
  bool success = false;

  success = setup_pthread_stack(esp, PHYS_BASE, t->tid * THREAD_STACK_SLOT_SIZE);
  if (!success) {
    return false;
  }

  uint8_t* sp = (uint8_t*)(*esp);

  sp -= sizeof(void*);
  *(void**)sp = arg;

  sp -= sizeof(pthread_fun);
  *(pthread_fun*)sp = tfun;

  sp -= sizeof(void*);
  *(void**)sp = 0;

  *esp = sp;
  *eip = sfun;
  return true;
}

/* Starts a new thread with a new user stack running SF, which takes
   TF and ARG as arguments on its user stack. This new thread may be
   scheduled (and may even exit) before pthread_execute () returns.
   Returns the new thread's TID or TID_ERROR if the thread cannot
   be created properly.

   This function will be implemented in Project 2: Multithreading and
   should be similar to process_execute (). For now, it does nothing.
   */
tid_t pthread_execute(stub_fun sf UNUSED, pthread_fun tf UNUSED, void* arg UNUSED) {
  struct thread_status_node* tsn = malloc(sizeof(struct thread_status_node));
  if (tsn == NULL) {
    return TID_ERROR;
  }
  status_node_init(tsn);

  struct thread* t = thread_current();

  pthread_arg_t* exec_args = malloc(sizeof(pthread_arg_t));
  if (exec_args == NULL) {
    free(tsn);
    return TID_ERROR;
  }

  list_push_back(&t->pcb->thread_statuses, &tsn->elem);

  exec_args->arg = arg;
  exec_args->status_node = tsn;
  exec_args->sfun = sf;
  exec_args->tfun = tf;
  exec_args->pcb = t->pcb;

  tid_t tid = thread_create("pthread", PRI_DEFAULT, start_pthread, exec_args);

  if (tid == TID_ERROR) {
    list_remove(&tsn->elem);
    free(tsn);
    free(exec_args);
  } else {
    tsn->tid = tid;
  }

  return tid;
}

/* A thread function that creates a new user thread and starts it
   running. Responsible for adding itself to the list of threads in
   the PCB.

   This function will be implemented in Project 2: Multithreading and
   should be similar to start_process (). For now, it does nothing. */
static void start_pthread(void* exec_ UNUSED) {
  pthread_arg_t* exec_args = (pthread_arg_t*)exec_;
  struct thread* t = thread_current();
  struct intr_frame if_;

  t->pcb = exec_args->pcb;
  t->status_node = exec_args->status_node;
  t->status_node->tid = t->tid;

  process_activate();

  memset(&if_, 0, sizeof if_);
  if_.gs = if_.fs = if_.es = if_.ds = if_.ss = SEL_UDSEG;
  if_.cs = SEL_UCSEG;
  if_.eflags = FLAG_IF | FLAG_MBS;

  bool success = setup_thread(exec_args->sfun, exec_args->tfun, exec_args->arg, &if_.eip, &if_.esp);
  free(exec_args);
  if (!success) {
    thread_exit();
    NOT_REACHED();
  }

  asm volatile("movl %0, %%esp; jmp intr_exit" : : "g"(&if_) : "memory");
  NOT_REACHED();
}

/* Waits for thread with TID to die, if that thread was spawned
   in the same process and has not been waited on yet. Returns TID on
   success and returns TID_ERROR on failure immediately, without
   waiting.

   This function will be implemented in Project 2: Multithreading. For
   now, it does nothing. */
tid_t pthread_join(tid_t tid UNUSED) {
  struct thread* cur_thread = thread_current();
  struct list* ts = &cur_thread->pcb->thread_statuses;

  // target tsn
  struct thread_status_node* tsn = NULL;

  struct list_elem* e;
  for (e = list_begin(ts); e != list_end(ts); e = list_next(e)) {
    struct thread_status_node* tsn_elem = list_entry(e, struct thread_status_node, elem);
    if (tsn_elem->tid == tid) {
      tsn = tsn_elem;
      break;
    }
  }

  if (tsn == NULL) {
    return TID_ERROR;
  }

  if (tsn->is_joined) {
    return TID_ERROR;
  }

  tsn->is_joined = true;
  if (tsn->is_exited) {
    list_remove(&tsn->elem);
    free(tsn);
    return tid;
  }

  sema_down(&tsn->join_sema);
  list_remove(&tsn->elem);
  free(tsn);
  return tid;
}

/* Free the current thread's resources. Most resources will
   be freed on thread_exit(), so all we have to do is deallocate the
   thread's userspace stack. Wake any waiters on this thread.

   The main thread should not use this function. See
   pthread_exit_main() below.

   This function will be implemented in Project 2: Multithreading. For
   now, it does nothing. */
void pthread_exit(void) {
  struct thread* cur = thread_current();

  struct thread_status_node* tsn = cur->status_node;
  if (tsn != NULL) {
    tsn->is_exited = true;
    sema_up(&tsn->join_sema);
  }

  thread_exit();
}

/* Only to be used when the main thread explicitly calls pthread_exit.
   The main thread should wait on all threads in the process to
   terminate properly, before exiting itself. When it exits itself, it
   must terminate the process in addition to all necessary duties in
   pthread_exit.

   This function will be implemented in Project 2: Multithreading. For
   now, it does nothing. */
void pthread_exit_main(void) {}

struct child_status* get_child_by_pid(pid_t pid) {
  struct thread* cur = thread_current();
  struct list* children_list = &cur->pcb->children;
  struct list_elem* e;

  for (e = list_begin(children_list); e != list_end(children_list); e = list_next(e)) {
    struct child_status* child = list_entry(e, struct child_status, elem);
    if (child->pid == pid) {
      return child;
    }
  }
  return NULL;
}

int store_fd(struct process* pcb, struct file* f, int fd) {
  if (pcb == NULL || f == NULL)
    return -1;

  // TODO: lock
  if (pcb->fd_table == NULL) {
    pcb->fd_table = malloc(sizeof(struct fd_table));
    if (pcb->fd_table == NULL) {
      return -1;
    }
    for (int i = 0; i < 128; i++) {
      pcb->fd_table->entries[i] = NULL;
      pcb->fd_table->inherited[i] = false;
    }
    pcb->fd_table->next_fd = 2;
  }

  /* Auto-assign: scan for a free slot starting from next_fd */
  if (fd == -1) {
    int start = pcb->fd_table->next_fd;
    for (int i = 0; i < 128; i++) {
      int slot = (start + i) % 128;
      if (slot < 2)
        continue; // skip stdin/stdout
      if (pcb->fd_table->entries[slot] == NULL) {
        pcb->fd_table->entries[slot] = f;
        pcb->fd_table->inherited[slot] = false;
        pcb->fd_table->next_fd = (slot + 1) % 128;
        if (pcb->fd_table->next_fd < 2)
          pcb->fd_table->next_fd = 2;
        return slot;
      }
    }
    return -1; // table full
  }

  /* Manual assignment: use the specified fd slot */
  if (fd < 2 || fd >= 128)
    return -1;

  pcb->fd_table->entries[fd] = f;
  pcb->fd_table->inherited[fd] = false;

  if (fd >= pcb->fd_table->next_fd) {
    pcb->fd_table->next_fd = fd + 1;
    if (pcb->fd_table->next_fd >= 128)
      pcb->fd_table->next_fd = 2;
  }

  return fd;
}

int remove_fd(struct process* pcb, int fd) {
  if (pcb == NULL || pcb->fd_table == NULL)
    return -1;

  /* stdin/stdout cannot be closed */
  if (fd == 0 || fd == 1)
    return 0;

  if (fd < 2 || fd >= 128)
    return -1;

  struct file* f = pcb->fd_table->entries[fd];
  if (f == NULL) {
    return -1;
  }

  pcb->fd_table->entries[fd] = NULL;

  if (fd < pcb->fd_table->next_fd) {
    pcb->fd_table->next_fd = fd;
  }

  return fd;
}

struct file* get_kernel_fd(struct process* pcb, int fd) {
  if (pcb == NULL || pcb->fd_table == NULL)
    return NULL;

  if (fd < 0 || fd >= 128)
    return NULL;

  return pcb->fd_table->entries[fd];
}