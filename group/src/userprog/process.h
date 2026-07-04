#ifndef USERPROG_PROCESS_H
#define USERPROG_PROCESS_H

#include "threads/interrupt.h"
#include "threads/thread.h"
#include <stdint.h>

// At most 8MB can be allocated to the stack
// These defines will be used in Project 2: Multithreading
#define MAX_STACK_PAGES (1 << 11)
#define MAX_THREADS 127
#define THREAD_STACK_SLOT_SIZE (1 << 20)
#define USER_LOCK_SIZE 256
#define USER_SEMA_SIZE 256

/* PIDs and TIDs are the same type. PID should be
   the TID of the main thread of the process */
typedef tid_t pid_t;

/* Thread functions (Project 2: Multithreading) */
typedef void (*pthread_fun)(void*);
typedef void (*stub_fun)(pthread_fun, void*);

struct fd_table {
  struct file* entries[128];
  bool inherited[128]; /* true if fd was inherited from parent via fork */
  int next_fd;
};

struct child_status {
  pid_t pid;                  /* 子进程的 PID */
  int exit_status;            /* 退出状态码 */
  bool is_alive;              /* 子进程是否还存活 */
  bool is_waited;             /* 父进程是否已经调用过 wait */
  struct semaphore wait_sema; /* 父进程 wait 时用于阻塞等待 */
  struct semaphore load_sema; /* 父进程 wait 时用于阻塞等待加载完成 */
  bool load_success;          /* 子进程是否成功加载 */
  struct list_elem elem;      /* 挂载到父进程 children 列表中的元素 */
};

/* The process control block for a given process. Since
   there can be multiple threads per process, we need a separate
   PCB from the TCB. All TCBs in a process will have a pointer
   to the PCB, and the PCB will have a pointer to the main thread
   of the process, which is `special`. */
struct process {
  /* Owned by process.c. */
  uint32_t* pagedir;          /* Page directory. */
  char process_name[16];      /* Name of the main thread */
  struct thread* main_thread; /* Pointer to main thread */

  struct list children;           /* 维护当前进程所有子进程状态的列表 */
  struct child_status* my_status; /* 指向本进程在父进程 children 列表中的档案 */
  struct fd_table* fd_table;      /* 文件描述符表 */
  struct file* exec_file;         /* 可执行文件，用于 ROX 保护 */
  struct list thread_statuses;    /* 进程中的所有线程 */

  struct lock* user_locks[USER_LOCK_SIZE];      // 索引 → 内核 lock 指针
  struct semaphore* user_semas[USER_SEMA_SIZE]; // 同理
};

void userprog_init(void);

pid_t process_execute(const char* file_name);
int process_wait(pid_t);
void process_exit(void);
void exit_process(int status);
void process_activate(void);
pid_t process_fork(struct intr_frame* f);

bool is_main_thread(struct thread*, struct process*);
pid_t get_pid(struct process*);

tid_t pthread_execute(stub_fun, pthread_fun, void*);
tid_t pthread_join(tid_t);
void pthread_exit(void);
void pthread_exit_main(void);

struct child_status* get_child_by_pid(pid_t pid);

int store_fd(struct process* pcb, struct file* f, int fd);
int remove_fd(struct process* pcb, int fd);
struct file* get_kernel_fd(struct process* pcb, int fd);

#endif /* userprog/process.h */
