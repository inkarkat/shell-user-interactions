#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationSpinner spins on both stdout and stderr and prints both" {
    run invocationSpinner --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-stdout
\\stdout again
| stderr
stderr again" ]
}

@test "invocationStderrSpinner spins only on stderr and prints only stdout" {
    run invocationStderrSpinner --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-stdout
stdout again
 " ]
}
