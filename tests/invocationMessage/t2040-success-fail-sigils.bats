#!/usr/bin/env bats

load fixture

@test "a successful command appends the passed success sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --fail FAILED true
    assert_control_output 'message: OK'
}

@test "a successful command does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --success OK --fail FAILED true
}

@test "a failing command appends the passed fail sigil" {
    run -1 invocationMessage --message 'message: ' --success OK --fail FAILED false
    assert_control_output 'message: FAILED'
}

@test "a failing command does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --success OK --fail FAILED false
}

@test "a successful command with clear appends the passed success sigil, waits, and erases" {
    run -0 invocationMessage --message 'message: ' --clear all --success OK --fail FAILED true
    assert_control_output "${S}message: OK${RE}"
}

@test "a failing command with clear appends the passed fail sigil, waits, and erases" {
    run -1 invocationMessage --message 'message: ' --clear all --success OK --fail FAILED false
    assert_control_output "${S}message: FAILED${RE}"
}
