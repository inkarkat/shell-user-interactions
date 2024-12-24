#!/usr/bin/env bats

load fixture

export INVOCATIONNOTIFICATION_SINK=/cannot/writeTo
[ -w "$INVOCATIONNOTIFICATION_SINK" ] && skip "cannot build a sink that cannot be written to"

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned" {
    run -1 invocationNotification --to title --message 'message: ' --clear all echo simplecommand
    assert_output 'simplecommand'
}

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned even if the command fails with another exit status" {
    run -1 invocationNotification --to title --message 'message: ' --clear all exit 42
    assert_output ''
}
