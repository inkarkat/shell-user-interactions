#!/usr/bin/env bats

export INVOCATIONNOTIFICATION_SINK=/cannot/writeTo
[ -w "$INVOCATIONNOTIFICATION_SINK" ] && skip "cannot build a sink that cannot be written to"

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned" {
    run invocationNotification --to overlay --message 'message: ' --clear all echo simplecommand

    [ $status -eq 1 ]
    [ "$output" = "simplecommand" ]
}

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned even if the command fails with another exit status" {
    run invocationNotification --to overlay --message 'message: ' --clear all exit 42

    [ $status -eq 1 ]
    [ "$output" = "" ]
}
