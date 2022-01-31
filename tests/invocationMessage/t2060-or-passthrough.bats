#!/usr/bin/env bats

load fixture

@test "with --or-passthrough, echo prints the message when the sink is writable" {
    run invocationMessage --or-passthrough --message 'message: ' --clear all --command 'echo commandline' echo simplecommand

    [ $status -eq 0 ]
    [ "$output" = "${S}message: commandline
simplecommand
${RE}" ]
}

@test "a failing silent command with passthrough returns its exit status" {
    NO_OUTPUT="message: "
    run invocationMessage --or-passthrough --message "$NO_OUTPUT" false

    [ $status -eq 1 ]
    [ "$output" = "$NO_OUTPUT" ]
}
