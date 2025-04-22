#!/usr/bin/env bats

load inline
load ../delayer

@test "single-line error from the command is suppressed because it falls within the initial delay" {
    run -0 invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_control_output ''
}

@test "two-line error from the command is suppressed because it falls within the initial delay" {
    run -0 invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    assert_control_output ''
}

@test "two-line error from the command prints second line because it falls just within the initial delay" {
    run -0 invocationMessage --message 'message: ' --initial-delay 1000ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    assert_control_output "message: ${S}2"
}

@test "multi-line error from the command prints third and subsequent lines" {
    run -0 invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "message: ${S}3${RE}4${RE}5"
}

@test "multi-line error from the command prints third and subsequent lines and then clears them" {
    run -0 invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --clear all --command 'seq 1 5 >&2'
    assert_control_output "${S}message: 3${RE}message: 4${RE}message: 5${RE}"
}

@test "a failing silent command with --initial-delay and --inline-stderr returns its exit status" {
    NO_OUTPUT="message: "
    run -1 invocationMessage --message "$NO_OUTPUT" --initial-delay 1250ms --timespan 0 --inline-stderr false
    assert_control_output ''
}
