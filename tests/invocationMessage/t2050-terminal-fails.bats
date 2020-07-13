#!/usr/bin/env bats

export INVOCATIONMESSAGE_SINK=/cannot/writeTo
[ -w "$INVOCATIONMESSAGE_SINK" ] && skip "cannot build a sink that cannot be written to"

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned" {
    run invocationMessage --message 'message: ' --clear all echo simplecommand

    [ $status -eq 1 ]
    [ "$output" = "simplecommand" ]
}

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned even if the command fails with another exit status" {
    run invocationMessage --message 'message: ' --clear all exit 42

    [ $status -eq 1 ]
    [ "$output" = "" ]
}
