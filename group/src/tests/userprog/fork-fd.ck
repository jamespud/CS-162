# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected ([<<'EOF']);
(fork-fd) begin
fork-fd: exit(0)
(fork-fd) end
fork-fd: exit(0)
EOF
pass;