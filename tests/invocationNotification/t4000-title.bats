#!/usr/bin/env bats

load title

@test "echo prints the message" {
    run -0 invocationNotification --to title --message 'message: ' echo executed
    assert_control_output "${R}message: ${N}executed"
}

@test "printf with clear prints and then erases the message" {
    run -0 invocationNotification --to title --message 'message: ' --clear all printf executed
    assert_control_output "${R}message: ${N}executed${C}"
}

@test "echo with clear prints and then erases the message" {
    run -0 invocationNotification --to title --message 'message: ' --clear all echo executed
    assert_control_output - <<EOF
${R}message: ${N}executed
${C}
EOF
}

@test "a failing command with clear appends the passed fail sigil, waits, and erases" {
    run -1 invocationNotification --to title --message 'message: ' --clear all --success OK --fail FAILED false
    assert_control_output "${R}message: ${N}${R}message: FAILED${N}${C}"
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs" {
    run -0 invocationNotification --to title --message 'message: ' --timespan 0 --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${R}message: OK${N}"
}

@test "multi-line error from the command powers a spinner and then cleared with sigil" {
    run -0 invocationNotification --to title --message 'message: ' --timespan 0 --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_control_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: OK${N}${C}"
}

