#!/usr/bin/env bats

load fixture

@test "full sweep cycle" {
    run invocationMessage --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 9 >&2'

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ][ -* ][  -*][   *][  *-][ *- ][*-  ][*   ]      " ]
}
