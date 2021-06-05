#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationTimedSweeper spins on both stdout and stderr and prints both" {
    run invocationTimedSweeper --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ]stdout
[ -* ]stdout again
[  -*]      stderr
stderr again" ]
}

@test "invocationTimedStderrSweeper spins only on stderr and prints only stdout" {
    run invocationTimedStderrSweeper --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ]stdout
stdout again
      " ]
}
