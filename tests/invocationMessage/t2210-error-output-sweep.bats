#!/usr/bin/env bats

load fixture

@test "full sweep cycle" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 9 >&2'
    assert_output 'message: [*   ][-*  ][ -* ][  -*][   *][  *-][ *- ][*-  ][*   ]      '
}
