#!/usr/bin/env bats

load overlay
load ../delayer

@test "single-line error from the command is suppressed because it falls within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1001ms --timespan 1000ms --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_control_output ''
}

@test "two-line error from the command appends second line because it falls just within the initial delay" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1000ms --timespan 1000ms --inline-stderr --command 'seq 1 2 >&2'
    assert_control_output "${R}message: 2${N}"
}

@test "multi-line error from the command appends third and then every second line" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1250ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: 3${N}${R}message: 5${N}${R}message: 7${N}${R}message: 9${N}"
}

@test "multi-line error from the command appends third and then every third line and then clears them" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 1250ms --timespan 1500ms --inline-stderr --clear all --command 'seq 1 10 >&2'
    assert_control_output "${R}message: 3${N}${R}message: 6${N}${R}message: 9${N}${C}"
}

@test "multi-line error from the command appends second and then every third line, then sigil, and then clears them" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 750ms --timespan 1500ms --inline-stderr --success OK --clear all --command 'seq 1 8 >&2'
    assert_control_output "${R}message: 2${N}${R}message: 5${N}${R}message: 8${N}${R}message: OK${N}${C}"
}

@test "large initial delay suppresses all output" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 4501ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output ''
}

@test "large initial delay suppresses all but the final line" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 4500ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: 9${N}"
}

@test "large initial delay suppresses all but the second-to-final line" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 4000ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: 8${N}"
}
