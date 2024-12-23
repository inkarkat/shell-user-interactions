#!/usr/bin/env bats

load fixture
export NO_OUTPUT='message: '

@test "a simple failing false returns its exit status" {
    run -1 invocationMessage --message 'message: ' false
    assert_output "$NO_OUTPUT"
}

@test "an exec'd failing false returns its exit status" {
    run -1 invocationMessage --message 'message: ' exec false
    assert_output "$NO_OUTPUT"
}

@test "an exit command returns its exit status" {
    run -42 invocationMessage --message 'message: ' exit 42
    assert_output "$NO_OUTPUT"
}
