# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected ([<<'EOF']);
(fork-offset) begin
fork-offset: exit(0)
(fork-offset) end
fork-offset: exit(0)
EOF
pass;