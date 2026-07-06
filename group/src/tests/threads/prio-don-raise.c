/* Tests that thread_set_priority correctly handles RAISING base priority
   during active priority donation.  The effective priority should remain
   at the donated level (max of new_base and donation), not be overwritten
   by the new base priority.

   This is the complement of priority-donate-lower, which tests LOWERING
   base priority during donation. */

#include <stdio.h>
#include "tests/threads/tests.h"
#include "threads/init.h"
#include "threads/synch.h"
#include "threads/thread.h"

static thread_func high_thread_func;

void test_prio_don_raise(void) {
  struct lock a;

  /* This test does not work with the MLFQS. */
  ASSERT(active_sched_policy == SCHED_PRIO);

  /* Make sure our priority is the default. */
  ASSERT(thread_get_priority() == PRI_DEFAULT);

  lock_init(&a);
  lock_acquire(&a);

  /* Create a higher-priority thread that will donate to us. */
  thread_create("high", PRI_DEFAULT + 10, high_thread_func, &a);
  msg("Main thread should have priority %d.  Actual priority: %d.",
      PRI_DEFAULT + 10, thread_get_priority());

  /* Raise base priority, but it should still be below the donation. */
  msg("Raising base priority...");
  thread_set_priority(PRI_DEFAULT + 5);
  msg("Main thread should have priority %d.  Actual priority: %d.",
      PRI_DEFAULT + 10, thread_get_priority());

  /* Release the lock.  The high thread will get it and finish. */
  lock_release(&a);
  msg("High thread should have just finished.");
  msg("Main thread should have priority %d.  Actual priority: %d.",
      PRI_DEFAULT + 5, thread_get_priority());
}

static void high_thread_func(void* lock_) {
  struct lock* lock = lock_;

  lock_acquire(lock);
  msg("High thread got the lock.");
  lock_release(lock);
  msg("High thread finished.");
}
