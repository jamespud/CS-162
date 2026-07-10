/* Tests buffer cache write coalescing: writes a 64 KiB file
   byte-by-byte and checks that the number of device writes is
   on the order of 128 (64 KiB = 128 blocks), not 65536. */

#include <syscall.h>
#include "tests/lib.h"
#include "tests/main.h"

void test_main(void) {
  static char one = 0x42;
  int fd, wr0, wr1, i;

  CHECK(create("f", 0), "create \"f\"");
  CHECK((fd = open("f")) > 1, "open \"f\"");

  cache_flush_all();
  wr0 = block_write_count();

  for (i = 0; i < 65536; i++)
    if (write(fd, &one, 1) != 1)
      fail("write failed at offset %d", i);

  cache_flush_all();
  wr1 = block_write_count();

  CHECK(wr1 - wr0 >= 64 && wr1 - wr0 < 1000, "write coalescing verified");

  close(fd);
}