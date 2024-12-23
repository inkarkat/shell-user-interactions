#!/usr/bin/env bats

load fixture

export INVOCATIONNOTIFICATION_SINK=/dev/null

@test "a simple failing false returns its exit status" {
    run -1 invocationNotification --to overlay --message 'message: ' false
    assert_output ''
}

@test "an exec'd failing false returns its exit status" {
    run -1 invocationNotification --to overlay --message 'message: ' exec false
    assert_output ''
}

@test "an exit command returns its exit status" {
    run -42 invocationNotification --to overlay --message 'message: ' exit 42
    assert_output ''
}
