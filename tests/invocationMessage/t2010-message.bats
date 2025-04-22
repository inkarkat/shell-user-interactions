#!/usr/bin/env bats

load fixture

@test "echo prints the message" {
    run -0 invocationMessage --message 'message: ' echo executed
    assert_control_output 'message: executed'
}

@test "printf with clear prints and then erases the message" {
    run -0 invocationMessage --message 'message: ' --clear all printf executed
    assert_control_output "${S}message: executed${RE}"
}

@test "echo with clear prints and then erases the message" {
    run -0 invocationMessage --message 'message: ' --clear all echo executed
    assert_control_output - <<EOF
${S}message: executed
${RE}
EOF
}

@test "echo with clear does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --clear all echo executed
}
