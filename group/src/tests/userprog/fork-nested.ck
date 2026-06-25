# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected ([<<'EOF', <<'EOF']);
(fork-nested) begin
(fork-nested) Testvar should be 1 but is 1
(fork-nested) Testvar should be 1 but is 1
(fork-nested) Testvar should be 2 but is 2
(fork-nested) Testvar should be 5 but is 5
(fork-nested) end
fork-nested: exit(0)
(fork-nested) Testvar should be 2 but is 2
(fork-nested) Testvar should be 2 but is 2
(fork-nested) end
fork-nested: exit(0)
(fork-nested) Testvar should be 1 but is 1
(fork-nested) end
fork-nested: exit(0)
EOF
(fork-nested) begin
(fork-nested) Testvar should be 1 but is 1
(fork-nested) Testvar should be 1 but is 1
(fork-nested) Testvar should be 2 but is 2
(fork-nested) Testvar should be 2 but is 2
(fork-nested) Testvar should be 5 but is 5
(fork-nested) end
fork-nested: exit(0)
(fork-nested) Testvar should be 2 but is 2
(fork-nested) end
fork-nested: exit(0)
(fork-nested) Testvar should be 1 but is 1
(fork-nested) end
fork-nested: exit(0)
EOF
pass;
