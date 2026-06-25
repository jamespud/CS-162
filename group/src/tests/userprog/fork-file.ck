# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected ([<<'EOF']);
(fork-file) begin
fork-file: exit(0)
(fork-file) end
fork-file: exit(0)
EOF
pass;