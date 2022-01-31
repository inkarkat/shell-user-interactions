#!/usr/bin/env bats

load fixture
load delayer

@test "message is suppressed because an immediate command execution falls within the initial delay" {
    run invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "message and sigil are suppressed because an immediate command execution falls within the initial delay" {
    run invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --success OK --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "message and clearing are suppressed because an immediate command execution falls within the initial delay" {
    run invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --clear all --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "a failing silent command with --initial-delay returns its exit status" {
    run invocationNotification --to overlay --message "message: " --initial-delay 1001ms  false
    [ $status -eq 1 ]
}
