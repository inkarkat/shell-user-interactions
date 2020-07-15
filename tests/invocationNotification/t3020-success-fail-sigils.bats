#!/usr/bin/env bats

load fixture
load overlay

@test "a successful command appends the passed success sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED true

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: OK${N}" ]
}

@test "a successful command does not delay" {
    assertNoDelay invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED true
}

@test "a failing command appends the passed fail sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "${R}message: ${N}${R}message: FAILED${N}" ]
}

@test "a failing command does not delay" {
    assertNoDelay invocationNotification --to overlay --message 'message: ' --success OK --fail FAILED false
}

@test "a successful command with clear appends the passed success sigil, waits, and erases" {
    run invocationNotification --to overlay --message 'message: ' --clear all --success OK --fail FAILED true

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: OK${N}${C}" ]
}

@test "a failing command with clear appends the passed fail sigil, waits, and erases" {
    run invocationNotification --to overlay --message 'message: ' --clear all --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "${R}message: ${N}${R}message: FAILED${N}${C}" ]
}
