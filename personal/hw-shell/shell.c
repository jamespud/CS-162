#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <termios.h>
#include <unistd.h>
#include <limits.h>

#include "tokenizer.h"

/* Convenience macro to silence compiler warnings about unused function
 * parameters. */
#define unused __attribute__((unused))

#define PATH_DELIM ":"
#define DIR_SPLIT "/"
#define PIPE_CHAR "|"

/* Whether the shell is connected to an actual terminal or not. */
bool shell_is_interactive;

/* File descriptor for the shell input */
int shell_terminal;

/* Terminal mode settings for the shell */
struct termios shell_tmodes;

/* Process group id for the shell */
pid_t shell_pgid;

char** path_array;
int path_arr_len;

int cmd_exit(struct tokens* tokens);
int cmd_help(struct tokens* tokens);
// int cmd_wc(struct tokens* tokens);
int cmd_pwd(struct tokens* tokens);
int cmd_cd(struct tokens* tokens);
bool run_external(struct tokens* tokens, int start, int end);

/* Built-in command functions take token array (see parse.h) and return int */
typedef int cmd_fun_t(struct tokens* tokens);

/* Built-in command struct and lookup table */
typedef struct fun_desc {
  cmd_fun_t* fun;
  char* cmd;
  char* doc;
} fun_desc_t;

typedef struct cmd_segment {
  int start;  // tokens 中的起始 index
  int end;    // tokens 中的结束 index（到 | 的前一个）
} cmd_segment_t;

fun_desc_t cmd_table[] = {
    {cmd_help, "?", "show this help menu"},
    {cmd_exit, "exit", "exit the command shell"},
    {cmd_pwd, "pwd", "show working dir"},
    {cmd_cd, "cd", "change dir"},
    // {cmd_wc, "/usr/bin/wc", "word count"},
};

int build_argv(struct tokens* tokens, int start, int end, char** argv,
               int out) {
  int n = 0;
  for (int i = start + 1; i < end; i++) {
    char* token = tokens_get_token(tokens, i);
    if (strcmp(token, "<") == 0 || strcmp(token, ">") == 0) {
      i++;
      continue;
    }
    argv[out + n] = token;
    n++;
  }
  argv[out + n] = NULL;
  return n;
}

void apply_redirection(struct tokens* tokens, int start, int end) {
  for (int i = start; i < end; i++) {
    char* token = tokens_get_token(tokens, i);
    if (strcmp(token, "<") == 0) {
      if (i + 1 >= end) {
        fprintf(stderr, "shell: syntax error near redirection\n");
        _exit(1);
      }
      char* filename = tokens_get_token(tokens, i + 1);
      int fd = open(filename, O_RDONLY);
      if (fd < 0) {
        fprintf(stderr, "shell: %s: No such file or directory\n", filename);
        _exit(1);
      }
      dup2(fd, STDIN_FILENO);
      close(fd);
      i++;
    } else if (strcmp(token, ">") == 0) {
      if (i + 1 >= end) {
        fprintf(stderr, "shell: syntax error near redirection\n");
        _exit(1);
      }
      char* filename = tokens_get_token(tokens, i + 1);
      int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0666);
      if (fd < 0) {
        fprintf(stderr, "shell: %s: No such file or directory\n", filename);
        _exit(1);
      }
      dup2(fd, STDOUT_FILENO);
      close(fd);
      i++;
    }
  }
}

/* Prints a helpful description for the given command */
int cmd_help(unused struct tokens* tokens) {
  for (unsigned int i = 0; i < sizeof(cmd_table) / sizeof(fun_desc_t); i++)
    printf("%s - %s\n", cmd_table[i].cmd, cmd_table[i].doc);
  return 1;
}

/* Exits this shell */
int cmd_exit(unused struct tokens* tokens) { exit(0); }

int cmd_pwd(unused struct tokens* tokens) {
  char buf[128];
  bool success = getcwd(buf, sizeof(buf));
  if (success) {
    printf("%s\n", buf);
  }
  return success;
}

int cmd_cd(struct tokens* tokens) {
  size_t argc = tokens_get_length(tokens);
  char* path;
  if (argc < 2) {
    printf("cd: missing argument\n");
    return 1;
  }
  path = tokens_get_token(tokens, 1);
  int ret = chdir(path);
  if (ret != 0) {
    printf("cd: %s: No such file or directory\n", path);
  }
  return ret;
}

/* Looks up the built-in command, if it exists. */
int lookup(char cmd[]) {
  for (unsigned int i = 0; i < sizeof(cmd_table) / sizeof(fun_desc_t); i++)
    if (cmd && (strcmp(cmd_table[i].cmd, cmd) == 0)) return i;
  return -1;
}

char* check_file_in_dir(const char* dir, const char* filename) {
  if (dir == NULL || filename == NULL) return NULL;

  size_t full_len = strlen(dir) + strlen(DIR_SPLIT) + strlen(filename) + 1;

  char* full_path = malloc(full_len);
  if (full_path == NULL) return NULL;

  strcpy(full_path, dir);
  size_t dir_len = strlen(dir);
  if (dir_len > 0 && dir[dir_len - 1] != DIR_SPLIT[0]) {
    strcat(full_path, DIR_SPLIT);
  }
  strcat(full_path, filename);

  if (access(full_path, X_OK) == 0) {
    return full_path;
  }

  free(full_path);
  return NULL;
}

char* lookup_path(char cmd[]) {
  char* final_path = NULL;
  final_path = check_file_in_dir("", cmd);

  if (final_path == NULL) {
    char buf[PATH_MAX];
    if (getcwd(buf, sizeof(buf)) != NULL) {
      final_path = check_file_in_dir(buf, cmd);
    }
  }

  if (final_path == NULL) {
    for (size_t i = 0; i < path_arr_len; i++) {
      final_path = check_file_in_dir(path_array[i], cmd);
      if (final_path != NULL) {
        break;
      }
    }
  }
  return final_path;
}

int cmd_run(char* full_path, struct tokens* tokens, int start, int end) {
  int span = end - start;
  char* argv[span + 2];  // argv[0]=full_path + 区间内 token + NULL
  argv[0] = full_path;
  build_argv(tokens, start, end, argv, 1);  // 从 argv[1] 开始填

  pid_t pid = fork();
  if (pid < 0) {
    perror("fork");
    free(full_path);
    return 1;
  }
  if (pid == 0) {
    apply_redirection(tokens, start, end);
    execv(full_path, argv);
    _exit(127);
  }
  int status;
  free(full_path);
  waitpid(pid, &status, 0);
  if (WIFEXITED(status)) return WEXITSTATUS(status);
  return -1;
}

void init_path() {
  char* raw_path = getenv("PATH");
  if (raw_path == NULL) return;

  char* path_copy = strdup(raw_path);
  if (path_copy == NULL) exit(1);

  path_array = NULL;
  int dir_count = 0;
  int capacity = 0;
  char* saveptr = NULL;

  char* token = strtok_r(path_copy, PATH_DELIM, &saveptr);
  while (token != NULL) {
    if (dir_count >= capacity) {
      capacity += 8;
      char** temp = realloc(path_array, capacity * sizeof(char*));
      if (temp == NULL) {
        perror("realloc failed");
        break;
      }
      path_array = temp;
    }
    path_array[dir_count] = strdup(token);
    if (path_array[dir_count] != NULL) {
      dir_count++;
    }

    token = strtok_r(NULL, PATH_DELIM, &saveptr);
  }
  path_arr_len = dir_count;
  free(path_copy);
}

int count_pipes(struct tokens* tokens) {
  int n = 0;
  size_t len = tokens_get_length(tokens);
  for (size_t i = 0; i < len; i++)
    if (strcmp(tokens_get_token(tokens, i), PIPE_CHAR) == 0) n++;
  return n;
}

cmd_segment_t* pipe_segment(struct tokens* tokens, int num_pipe) {
  int num_procs = num_pipe + 1;
  cmd_segment_t* segs = malloc(sizeof(cmd_segment_t) * num_procs);
  if (!segs) {
    perror("malloc");
    exit(1);
  }

  size_t len = tokens_get_length(tokens);
  int seg_idx = 0;
  int seg_start = 0;
  for (size_t i = 0; i < len; i++) {
    char* token = tokens_get_token(tokens, i);
    if (strcmp(token, PIPE_CHAR) == 0) {
      segs[seg_idx].start = seg_start;
      segs[seg_idx].end = (int)i;  // 半开：不含 |
      seg_idx++;
      seg_start = (int)i + 1;  // 下一段从 | 之后开始
    }
  }
  // 最后一段
  segs[seg_idx].start = seg_start;
  segs[seg_idx].end = (int)len;
  return segs;
}

void cmd_pipe(struct tokens* tokens, int num_pipe) {
  int num_procs = num_pipe + 1;
  int fds[num_pipe][2];  // num_pipe=0 时为 VLA[0]，单命令不该走这里
  for (int i = 0; i < num_pipe; i++) {
    if (pipe(fds[i]) < 0) {
      perror("pipe");
      exit(1);
    }
  }

  cmd_segment_t* segs = pipe_segment(tokens, num_pipe);
  pid_t pids[num_procs];

  for (int i = 0; i < num_procs; i++) {
    pids[i] = fork();
    if (pids[i] < 0) {
      perror("fork");
      exit(1);
    }
    if (pids[i] == 0) {
      // 子进程：连接 pipe
      if (i > 0) dup2(fds[i - 1][0], STDIN_FILENO);
      if (i < num_procs - 1) dup2(fds[i][1], STDOUT_FILENO);
      // 关闭本进程持有的全部 pipe fd（dup2 已复制，原始 fd 可关）
      for (int j = 0; j < num_pipe; j++) {
        close(fds[j][0]);
        close(fds[j][1]);
      }
      // 文件重定向（覆盖 pipe dup2，显式重定向优先）
      apply_redirection(tokens, segs[i].start, segs[i].end);
      // 解析并 exec
      char* cmd = tokens_get_token(tokens, segs[i].start);
      char* full_path = lookup_path(cmd);
      if (!full_path) {
        fprintf(stderr, "shell: %s: command not found\n", cmd);
        _exit(127);
      }
      int span = segs[i].end - segs[i].start;
      char* argv[span + 2];
      argv[0] = full_path;
      build_argv(tokens, segs[i].start, segs[i].end, argv, 1);
      execv(full_path, argv);
      _exit(127);
    }
  }

  // 父进程：关闭全部 pipe fd
  for (int j = 0; j < num_pipe; j++) {
    close(fds[j][0]);
    close(fds[j][1]);
  }
  // 等待全部子进程
  for (int i = 0; i < num_procs; i++) {
    int status;
    waitpid(pids[i], &status, 0);
  }
  free(segs);
}
void destroy_path() {
  for (int i = 0; i < path_arr_len; i++) {
    free(path_array[i]);
  }
  free(path_array);
}

bool run_external(struct tokens* tokens, int start, int end) {
  char* cmd = tokens_get_token(tokens, start);
  char* full_path = lookup_path(cmd);
  if (full_path == NULL) return false;
  cmd_run(full_path, tokens, start, end);
  return true;
}

/* Intialization procedures for this shell */
void init_shell() {
  /* Our shell is connected to standard input. */
  shell_terminal = STDIN_FILENO;

  /* Check if we are running interactively */
  shell_is_interactive = isatty(shell_terminal);

  if (shell_is_interactive) {
    /* If the shell is not currently in the foreground, we must pause the shell
     * until it becomes a foreground process. We use SIGTTIN to pause the shell.
     * When the shell gets moved to the foreground, we'll receive a SIGCONT. */
    while (tcgetpgrp(shell_terminal) != (shell_pgid = getpgrp()))
      kill(-shell_pgid, SIGTTIN);

    /* Saves the shell's process id */
    shell_pgid = getpid();

    /* Take control of the terminal */
    tcsetpgrp(shell_terminal, shell_pgid);

    /* Save the current termios to a variable, so it can be restored later. */
    tcgetattr(shell_terminal, &shell_tmodes);
  }
}

int main(unused int argc, unused char* argv[]) {
  init_shell();
  init_path();

  static char line[4096];
  int line_num = 0;

  /* Please only print shell prompts when standard input is not a tty */
  if (shell_is_interactive) fprintf(stdout, "%d: ", line_num);

  while (fgets(line, 4096, stdin)) {
    /* Split our line into words. */
    struct tokens* tokens = tokenize(line);
    int argc = tokens_get_length(tokens);

    if (argc == 0) {
      if (shell_is_interactive) fprintf(stdout, "%d: ", ++line_num);
      tokens_destroy(tokens);
      continue;
    }

    char* cmd = tokens_get_token(tokens, 0);

    /* Find which built-in function to run. */
    int fundex = lookup(cmd);
    if (fundex >= 0) {
      cmd_table[fundex].fun(tokens);
    } else if (fundex == -1) {
      int num_pipe = count_pipes(tokens);
      if (num_pipe > 0) {
        cmd_pipe(tokens, num_pipe);
      } else if ((fundex = lookup(cmd)) >= 0) {
        cmd_table[fundex].fun(tokens);
      } else {
        bool ran = run_external(tokens, 0, argc);
        if (!ran)
          fprintf(stdout, "This shell doesn't know how to run programs.\n");
      }
    }

    if (shell_is_interactive)
      /* Please only print shell prompts when standard input is not a tty */
      fprintf(stdout, "%d: ", ++line_num);

    /* Clean up memory */
    tokens_destroy(tokens);
  }

  destroy_path();

  return 0;
}
