#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationSweeper spins on both stdout and stderr and prints both" {
    run invocationSweeper --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ]stdout
[ -* ]stdout again
[  -*]      stderr
stderr again" ]
}

@test "invocationStderrSweeper spins only on stderr and prints only stdout" {
    run invocationStderrSweeper --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ]stdout
stdout again
      " ]
}
