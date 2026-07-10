# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected (IGNORE_EXIT_CODES => 1, [<<'EOF']);
(cache-whole) begin
(cache-whole) create "f"
(cache-whole) open "f"
(cache-whole) block writes verified
(cache-whole) no read-before-write verified
(cache-whole) end
EOF
pass;