#!/usr/bin/env bats

load fixture
load notify

@test "echo launches notify with the message" {
    run invocationNotification --to notify --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "invocationNotification -- message: "
}

@test "printf with clear launches notify and then launches notify with empty argument" {
    run invocationNotification --to notify --message 'message: ' --clear all printf executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "invocationNotification -- message:${SP}
invocationNotification --"
}

@test "echo with clear launches notify and then launches notify with empty argument" {
    run invocationNotification --to notify --message 'message: ' --clear all echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "invocationNotification -- message:${SP}
invocationNotification --"
}

@test "a failing command with clear launches notify, then again with appended fail sigil, then with empty argument" {
    run invocationNotification --to notify --message 'message: ' --clear all --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "" ]
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: FAILED
invocationNotification --"
}

@test "multi-line error from the command is individually passed to command and finally message with sigil as the command runs" {
    run invocationNotification --to notify --message 'message: ' --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: from command
invocationNotification -- message: more from command
invocationNotification -- message: OK"
}

@test "multi-line error from the command passes message and spinner, then sigil, then empty argument to command" {
    run invocationNotification --to notify --message 'message: ' --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: /
invocationNotification -- message: -
invocationNotification -- message: OK
invocationNotification --"
}
