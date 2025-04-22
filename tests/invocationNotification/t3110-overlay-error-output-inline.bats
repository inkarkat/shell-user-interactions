#!/usr/bin/env bats

load overlay

@test "single-line error from the command is individually appended to the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}"
}

@test "multi-line error from the command is individually appended to the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}"
}

@test "single-line error from the command is individually appended to the message and sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: OK${N}"
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${R}message: OK${N}"
}

@test "single-line error from the command is individually appended and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-stderr --clear all --command "$SINGLE_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${C}"
}

@test "multi-line error from the command is individually appended and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-stderr --clear all --command "$MULTI_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${C}"
}

@test "single-line error from the command is individually appended and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: OK${N}${C}"
}

@test "multi-line error from the command is individually appended and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${R}message: OK${N}${C}"
}

@test "empty line error from the command is ignored" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-stderr --command "$WITH_EMPTY_ERROR_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: foo${N}${R}message: bar${N}${R}message: bar${N}"
}

@test "multi-line error that contains the statusline marker is not individually appended" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-stderr --command '{ echo first; echo -e \\x01666; echo last; } >&2'
    assert_control_output "${R}message: ${N}${R}message: first${N}${R}message: last${N}"
}
