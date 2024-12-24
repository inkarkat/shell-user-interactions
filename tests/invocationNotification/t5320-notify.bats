#!/usr/bin/env bats

load notify

@test "echo launches notify with the message" {
    run -0 invocationNotification --to notify --message 'message: ' echo executed
    assert_output 'executed'
    assert_runs 'invocationNotification -- message: '
}

@test "printf with clear launches notify and then launches notify with empty argument" {
    run -0 invocationNotification --to notify --message 'message: ' --clear all printf executed
    assert_output 'executed'
    assert_runs "invocationNotification -- message:${SP}
invocationNotification --"
}

@test "echo with clear launches notify and then launches notify with empty argument" {
    run -0 invocationNotification --to notify --message 'message: ' --clear all echo executed
    assert_output 'executed'
    assert_runs "invocationNotification -- message:${SP}
invocationNotification --"
}

@test "a failing command with clear launches notify, then again with appended fail sigil, then with empty argument" {
    run -1 invocationNotification --to notify --message 'message: ' --clear all --success OK --fail FAILED false
    assert_output ''
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: FAILED
invocationNotification --"
}

@test "multi-line error from the command is individually passed to command and finally message with sigil as the command runs" {
    run -0 invocationNotification --to notify --message 'message: ' --timespan 0 --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_output ''
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: from command
invocationNotification -- message: more from command
invocationNotification -- message: OK"
}

@test "multi-line error from the command passes message and spinner, then sigil, then empty argument to command" {
    run -0 invocationNotification --to notify --message 'message: ' --timespan 0 --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output ''
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: /
invocationNotification -- message: -
invocationNotification -- message: OK
invocationNotification --"
}
