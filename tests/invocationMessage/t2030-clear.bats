#!/usr/bin/env bats

load fixture

@test "a successful command with clear all erases" {
    run -0 invocationMessage --message 'message: ' --clear all true
    assert_output "${S}message: ${RE}"
}

@test "a successful command with clear success erases" {
    run -0 invocationMessage --message 'message: ' --clear success true
    assert_output "${S}message: ${RE}"
}

@test "a successful command with clear failure does not erase" {
    run -0 invocationMessage --message 'message: ' --clear failure true
    assert_output "${S}message: "
}

@test "a successful silent command with clear no-error-output erases" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -0 invocationMessage --message 'message: ' --clear no-error-output true
    assert_output "${S}message: ${RE}"
}

@test "a successful outputting command with clear no-error-output does not erase" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -0 invocationMessage --message 'message: ' --clear no-error-output --command "$MULTI_LINE_COMMAND"
    assert_output - <<EOF
${S}message:${SP}
from command
more from command
EOF
}

@test "a failing command with clear all erases" {
    run -1 invocationMessage --message 'message: ' --clear all false
    assert_output "${S}message: ${RE}"
}

@test "a failing command with clear failure erases" {
    run -1 invocationMessage --message 'message: ' --clear failure false
    assert_output "${S}message: ${RE}"
}

@test "a failing command with clear success does not erase" {
    run -1 invocationMessage --message 'message: ' --clear success false
    assert_output "${S}message: "
}

@test "a failing silent command with clear no-error-output erases" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -1 invocationMessage --message 'message: ' --clear no-error-output false
    assert_output "${S}message: ${RE}"
}

@test "a failing outputting command with clear no-error-output does not erase" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -1 invocationMessage --message 'message: ' --clear no-error-output --command "$MULTI_LINE_COMMAND" --command false
    assert_output - <<EOF
${S}message:${SP}
from command
more from command
EOF
}
