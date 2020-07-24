#!/usr/bin/env bats

load fixture
load delayer

@test "message is suppressed because an immediate command execution falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "message and sigil are suppressed because an immediate command execution falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --success OK --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "message and clearing are suppressed because an immediate command execution falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --clear all --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}
