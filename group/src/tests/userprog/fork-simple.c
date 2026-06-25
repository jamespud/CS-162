#include <syscall.h>
#include "tests/lib.h"
#include "tests/main.h"

int a = 1;

void test_main(void) {
  int b = 1;

  pid_t pid = fork();
  if (pid < 0)
    fail("fork returned %d", pid);
  else if (pid == 0) {
    a++;
    b--;
    msg("Child sees a as %d", a);
    msg("Child sees b as %d", b);
  } else {
    a--;
    b++;
    wait(pid);
    msg("Parent sees a as %d", a);
    msg("Parent sees b as %d", b);
  }
}
