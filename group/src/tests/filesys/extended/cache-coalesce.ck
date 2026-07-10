# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected (IGNORE_EXIT_CODES => 1, [<<'EOF']);
(cache-coalesce) begin
(cache-coalesce) create "f"
(cache-coalesce) open "f"
(cache-coalesce) write coalescing verified
(cache-coalesce) end
EOF
pass;