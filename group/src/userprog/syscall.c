#include "userprog/syscall.h"
#include "devices/shutdown.h"
#include "filesys/directory.h"
#include "filesys/file.h"
#include "filesys/filesys.h"
#include "filesys/inode.h"
#include "threads/interrupt.h"
#include "threads/malloc.h"
#include "threads/synch.h"
#include "threads/thread.h"
#include "threads/vaddr.h"
#include "userprog/pagedir.h"
#include "userprog/process.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syscall-nr.h>

static void syscall_handler(struct intr_frame*);
static void check_valid_ptr(const void* vaddr);
static void check_valid_bytes(const void* vaddr, size_t size);
static size_t safe_strlen(const void* vaddr);
void exit_process(int status);

void syscall_init(void) {
  intr_register_int(0x30, 3, INTR_ON, syscall_handler, "syscall");
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

static bool syscall_chdir(const char* dir) {
  char target_name[NAME_MAX + 1];
  struct dir* parent = path_lookup(dir, target_name);
  if (parent == NULL)
    return false;

  struct inode* target_inode = NULL;

  if (strlen(target_name) == 0) {
    target_inode = inode_reopen(dir_get_inode(parent));
  } else {
    dir_lookup(parent, target_name, &target_inode);
  }

  if (target_inode == NULL || !inode_is_dir(target_inode)) {
    inode_close(target_inode);
    dir_close(parent);
    return false;
  }

  dir_close(thread_current()->cwd);
  thread_current()->cwd = dir_open(target_inode);

  dir_close(parent);
  return true;
}

static bool syscall_mkdir(const char* dir) {
  char target_name[NAME_MAX + 1];
  struct dir* parent = path_lookup(dir, target_name);
  if (parent == NULL || strlen(target_name) == 0) {
    dir_close(parent);
    return false;
  }

  bool success = dir_create_subdirectory(parent, target_name);

  dir_close(parent);
  return success;
}

static bool syscall_readdir(int fd, char* name) {
  struct thread* t = thread_current();
  if (fd < 0 || fd >= 128) {
    return false;
  }
  if (t->pcb->fd_table == NULL)
    return false;
  struct file* f = t->pcb->fd_table->entries[fd];
  if (f == NULL) {
    return false;
  }

  if (!inode_is_dir(file_get_inode(f))) {
    return false;
  }

  off_t pos = file_tell(f);
  bool ok = dir_readdir_at(file_get_inode(f), &pos, name);
  file_seek(f, pos);
  return ok;
}

static bool syscall_isdir(int fd) {
  struct thread* t = thread_current();
  if (fd < 0 || fd >= 128) {
    return false;
  }
  if (t->pcb->fd_table == NULL)
    return false;
  struct file* f = t->pcb->fd_table->entries[fd];
  return inode_is_dir(file_get_inode(f));
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

  if (args[0] == SYS_EXIT) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    f->eax = args[1];
    exit_process((int)args[1]);
  } else if (args[0] == SYS_WRITE) {
    check_valid_bytes(args, 4 * sizeof(uint32_t));
    int fd = (int)args[1];
    const void* buffer = (const void*)args[2];
    unsigned size = (unsigned)args[3];

    if (fd == 1) {
      check_valid_bytes(buffer, size);
      putbuf(buffer, size);
      f->eax = size;
    } else {
      struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
      if (file_ptr == NULL) {
        f->eax = -1;
      } else if (inode_is_dir(file_get_inode(file_ptr))) {
        f->eax = -1;
      } else {
        check_valid_bytes(buffer, size);
        f->eax = file_write(file_ptr, buffer, size);
      }
    }
  } else if (args[0] == SYS_PRACTICE) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    f->eax = args[1] + 1;
  } else if (args[0] == SYS_HALT) {
    shutdown_power_off();
  } else if (args[0] == SYS_EXEC) {
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
  } else if (args[0] == SYS_WAIT) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    struct child_status* child_status = get_child_by_pid((pid_t)args[1]);

    if (child_status == NULL) {
      f->eax = -1;
      return;
    }
    if (child_status->is_waited) {
      f->eax = -1;
      return;
    }

    if (child_status->is_alive) {
      sema_down(&child_status->wait_sema);
    }

    child_status->is_waited = true;
    f->eax = child_status->exit_status;
    list_remove(&child_status->elem);
    free(child_status);
  } else if (args[0] == SYS_FORK) {
    f->eax = process_fork(f);
  } else if (args[0] == SYS_CREATE) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    const char* file = (const char*)args[1];
    unsigned initial_size = (unsigned)args[2];
    check_valid_bytes(file, safe_strlen(file) + 1);
    f->eax = filesys_create(file, initial_size);
  } else if (args[0] == SYS_REMOVE) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    const char* file = (const char*)args[1];
    check_valid_bytes(file, safe_strlen(file) + 1);
    f->eax = filesys_remove(file);
  } else if (args[0] == SYS_OPEN) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    const char* file = (const char*)args[1];
    check_valid_bytes(file, safe_strlen(file) + 1);
    struct file* file_ptr = filesys_open(file);
    if (file_ptr == NULL) {
      f->eax = -1;
    } else {
      f->eax = store_fd(thread_current()->pcb, file_ptr, -1);
    }
  } else if (args[0] == SYS_FILESIZE) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    int fd = (int)args[1];
    struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
    if (file_ptr == NULL) {
      f->eax = -1;
    } else {
      f->eax = file_length(file_ptr);
    }
  } else if (args[0] == SYS_READ) {
    check_valid_bytes(args, 4 * sizeof(uint32_t));
    int fd = (int)args[1];
    void* buffer = (void*)args[2];
    unsigned size = (unsigned)args[3];
    check_valid_bytes(buffer, size);
    struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
    if (file_ptr == NULL) {
      f->eax = -1;
    } else if (inode_is_dir(file_get_inode(file_ptr))) {
      f->eax = -1;
    } else {
      f->eax = file_read(file_ptr, buffer, size);
    }
  } else if (args[0] == SYS_SEEK) {
    check_valid_bytes(args, 3 * sizeof(uint32_t));
    int fd = (int)args[1];
    unsigned position = (unsigned)args[2];
    struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
    if (file_ptr != NULL) {
      file_seek(file_ptr, position);
    }
  } else if (args[0] == SYS_TELL) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    int fd = (int)args[1];
    struct file* file_ptr = (struct file*)get_kernel_fd(thread_current()->pcb, fd);
    if (file_ptr == NULL) {
      f->eax = -1;
    } else {
      f->eax = file_tell(file_ptr);
    }
  } else if (args[0] == SYS_CLOSE) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    int fd = (int)args[1];
    struct process* pcb = thread_current()->pcb;
    struct file* file_ptr = (struct file*)get_kernel_fd(pcb, fd);
    /* Skip file_close for inherited fds to avoid double-close on shared struct file */
    if (file_ptr != NULL) {
      bool inherited =
          (fd >= 0 && fd < 128 && pcb->fd_table != NULL && pcb->fd_table->inherited[fd]);
      if (!inherited)
        file_close(file_ptr);
    }
    remove_fd(pcb, fd);
  } else if (args[0] == SYS_INUMBER) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    int fd = (int)args[1];
    struct file* file = get_kernel_fd(thread_current()->pcb, fd);
    if (file == NULL) {
      f->eax = -1;
    } else {
      f->eax = inode_get_inumber(file_get_inode(file));
    }
  } else if (args[0] == SYS_CHDIR) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    const char* path = (const char*)args[1];
    check_valid_bytes(path, safe_strlen(path) + 1);
    f->eax = syscall_chdir(path);
  } else if (args[0] == SYS_MKDIR) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    const char* path = (const char*)args[1];
    check_valid_bytes(path, safe_strlen(path) + 1);
    f->eax = syscall_mkdir(path);
  } else if (args[0] == SYS_READDIR) {
    check_valid_bytes(args, 3 * sizeof(uint32_t));
    char* name = (char*)args[2];
    check_valid_bytes(name, NAME_MAX + 1);
    f->eax = syscall_readdir((int)args[1], name);
  } else if (args[0] == SYS_ISDIR) {
    check_valid_bytes(args, 2 * sizeof(uint32_t));
    f->eax = syscall_isdir((int)args[1]);
  }
}
