# -*- perl -*-
use strict;
use warnings;
use tests::tests;
check_expected ([<<'EOF']);
(prio-don-raise) begin
(prio-don-raise) Main thread should have priority 41.  Actual priority: 41.
(prio-don-raise) Raising base priority...
(prio-don-raise) Main thread should have priority 41.  Actual priority: 41.
(prio-don-raise) High thread got the lock.
(prio-don-raise) High thread finished.
(prio-don-raise) High thread should have just finished.
(prio-don-raise) Main thread should have priority 36.  Actual priority: 36.
(prio-don-raise) end
EOF
pass;
