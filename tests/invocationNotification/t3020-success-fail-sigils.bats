#!/usr/bin/env bats

load overlay

@test "a successful command appends the passed success sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED true
    assert_output "${R}message: ${N}${R}message: OK${N}"
}

@test "a successful command does not delay" {
    assertNoDelay invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED true
}

@test "a failing command appends the passed fail sigil" {
    run -1 invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED false
    assert_output "${R}message: ${N}${R}message: FAILED${N}"
}

@test "a failing command does not delay" {
    assertNoDelay invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED false
}

@test "a successful command with clear appends the passed success sigil, waits, and erases" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all --success OK --fail FAILED true
    assert_output "${R}message: ${N}${R}message: OK${N}${C}"
}

@test "a failing command with clear appends the passed fail sigil, waits, and erases" {
    run -1 invocationNotification --to overlay --message 'message: ' --clear all --success OK --fail FAILED false
    assert_output "${R}message: ${N}${R}message: FAILED${N}${C}"
}
