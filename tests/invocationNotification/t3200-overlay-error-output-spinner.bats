#!/usr/bin/env bats

load overlay

@test "single-line error from the command powers a spinner after the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr --command "$SINGLE_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: ${N}"
}

@test "multi-line error from the command powers a spinner after the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: ${N}"
}

@test "full spin cycle" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: /${N}${R}message: ${N}"
}

@test "single-line error from the command powers a spinner after the message and sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: OK${N}"
}

@test "single-line error from the command powers a spinner after the message and ignores a fail sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr --fail FAIL --command "$SINGLE_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: ${N}"
}

@test "multi-line error from the command powers a spinner after the message and sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: OK${N}"
}

@test "single-line error from the command powers a spinner and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr --clear all --command "$SINGLE_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${C}"
}

@test "single-line error from the command powers a spinner and ignores a fail clear" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr --clear failure --command "$SINGLE_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: ${N}"
}

@test "multi-line error from the command powers a spinner and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --clear all --command "$MULTI_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${C}"
}

@test "single-line error from the command powers a spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: OK${N}${C}"
}

@test "multi-line error from the command powers a spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: OK${N}${C}"
}

@test "empty line output from the command does not rotate the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command "$WITH_EMPTY_ERROR_COMMAND"
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: ${N}"
}

@test "multi-line error that contains the statusline marker does not rotate the spinner but clears it temporarily" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: ${N}${R}message: -${N}${R}message: ${N}"
}
