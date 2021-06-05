#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationTimedSpinner spins on both stdout and stderr and prints both" {
    run invocationTimedSpinner --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-stdout
\\stdout again
| stderr
stderr again" ]
}

@test "invocationTimedStderrSpinner spins only on stderr and prints only stdout" {
    run invocationTimedStderrSpinner --message 'message: ' --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-stdout
stdout again
 " ]
}
