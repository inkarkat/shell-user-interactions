#!/usr/bin/env bats

load ../delayer

@test "message is suppressed because an immediate command execution falls within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --command true
    assert_output ''
}

@test "message and sigil are suppressed because an immediate command execution falls within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --success OK --command true
    assert_output ''
}

@test "message and clearing are suppressed because an immediate command execution falls within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --clear all --command true
    assert_output ''
}

@test "a failing silent command with --initial-delay returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --initial-delay 1001ms  false
}
