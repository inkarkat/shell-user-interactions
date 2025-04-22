#!/usr/bin/env bats

load overlay

@test "multi-line error from the command is printed after creating and before clearing the overlay" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"
    assert_control_output - <<EOF
${R}message: ${N}from command
more from command
${C}
EOF
}
