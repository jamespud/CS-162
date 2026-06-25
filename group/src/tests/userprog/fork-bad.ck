# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected (IGNORE_USER_FAULTS => 1, [<<'EOF']);
(fork-bad) begin
fork-bad: exit(-1)
(fork-bad) Child process exited with -1
(fork-bad) end
fork-bad: exit(0)
EOF
pass;