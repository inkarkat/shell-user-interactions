#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationTimedSweeper spins on both stdout and stderr and prints both" {
    run -0 invocationTimedSweeper --message 'message: ' --command "$BOTH_COMMAND"
    [ "$output" = "message: [*   ][-*  ]stdout
[ -* ]stdout again
[  -*]      stderr
stderr again" ]
}

@test "invocationTimedStderrSweeper spins only on stderr and prints only stdout" {
    run -0 invocationTimedStderrSweeper --message 'message: ' --command "$BOTH_COMMAND"
    [ "$output" = "message: [*   ][-*  ]stdout
stdout again
      " ]
}
