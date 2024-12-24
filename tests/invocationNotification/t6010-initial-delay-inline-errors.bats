#!/usr/bin/env bats

load overlay
load delayer

@test "single-line error from the command is suppressed because it falls within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_output ''
}

@test "two-line error from the command is suppressed because it falls within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    assert_output ''
}

@test "two-line error from the command appends second line because it falls just within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1000ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    assert_output "${R}message: 2${N}"
}

@test "multi-line error from the command appends third and subsequent lines" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: 3${N}${R}message: 4${N}${R}message: 5${N}"
}

@test "multi-line error from the command appends third and subsequent lines and then clears them" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --clear all --command 'seq 1 5 >&2'
    assert_output "${R}message: 3${N}${R}message: 4${N}${R}message: 5${N}${C}"
}

@test "a failing silent command with --initial-delay --inline-stderr returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --initial-delay 1001ms --timespan 0 --inline-stderr false
}
