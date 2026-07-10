/* Tests that full-block writes (512-byte aligned) do not trigger
   unnecessary block_read calls.  Writes 100 KiB (200 blocks) in 512-byte
   chunks and checks that the device write count is on the order of 200
   while the read count remains small (metadata only). */

#include <random.h>
#include <syscall.h>
#include "tests/lib.h"
#include "tests/main.h"

void test_main(void) {
  static char blk[512];
  int fd, wr0, wr1, rd0, rd1, i;

  random_bytes(blk, sizeof blk);

  CHECK(create("f", 0), "create \"f\"");
  CHECK((fd = open("f")) > 1, "open \"f\"");

  cache_flush_all();
  wr0 = block_write_count();
  rd0 = block_read_count();

  for (i = 0; i < 200; i++)
    if (write(fd, blk, 512) != 512)
      fail("write failed at block %d", i);

  cache_flush_all();
  wr1 = block_write_count();
  rd1 = block_read_count();

  CHECK(wr1 - wr0 >= 200 && wr1 - wr0 < 500, "block writes verified");
  CHECK(rd1 - rd0 < 64, "no read-before-write verified");

  close(fd);
}