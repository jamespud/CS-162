# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected ([<<'EOF']);
(fork-simple) begin
(fork-simple) Child sees a as 2
(fork-simple) Child sees b as 0
(fork-simple) end
fork-simple: exit(0)
(fork-simple) Parent sees a as 0
(fork-simple) Parent sees b as 2
(fork-simple) end
fork-simple: exit(0)
EOF
pass;