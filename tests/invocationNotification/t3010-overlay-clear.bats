#!/usr/bin/env bats

load overlay

@test "a successful command with clear all erases" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all true
    assert_control_output "${R}message: ${N}${C}"
}

@test "a successful command with clear success erases" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear success true
    assert_control_output "${R}message: ${N}${C}"
}

@test "a successful command with clear failure does not erase" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear failure true
    assert_control_output "${R}message: ${N}"
}

@test "a failing command with clear all erases" {
    run -1 invocationNotification --to overlay --message 'message: ' --clear all false
    assert_control_output "${R}message: ${N}${C}"
}

@test "a failing command with clear failure erases" {
    run -1 invocationNotification --to overlay --message 'message: ' --clear failure false
    assert_control_output "${R}message: ${N}${C}"
}

@test "a failing command with clear success does not erase" {
    run -1 invocationNotification --to overlay --message 'message: ' --clear success false
    assert_control_output "${R}message: ${N}"
}
