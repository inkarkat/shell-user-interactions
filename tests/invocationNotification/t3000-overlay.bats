#!/usr/bin/env bats

load overlay

@test "echo prints the message" {
    run -0 invocationNotification --to overlay --message 'message: ' echo executed
    assert_output "${R}message: ${N}executed"
}

@test "printf with clear prints and then erases the message" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all printf executed
    assert_output "${R}message: ${N}executed${C}"
}

@test "echo with clear prints and then erases the message" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all echo executed
    assert_output - <<EOF
${R}message: ${N}executed
${C}
EOF
}

@test "echo with clear does not delay" {
    assertNoDelay invocationNotification --to overlay --message 'message: ' --clear all echo executed
}
