#!/usr/bin/env bats

load fixture

@test "a successful command appends the passed success sigil" {
    run invocationMessage --message 'message: ' --success OK --fail FAILED true

    [ $status -eq 0 ]
    [ "$output" = "message: OK" ]
}

@test "a successful command does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --success OK --fail FAILED true
}

@test "a failing command appends the passed fail sigil" {
    run invocationMessage --message 'message: ' --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "message: FAILED" ]
}

@test "a failing command does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --success OK --fail FAILED false
}

@test "a successful command with clear appends the passed success sigil, waits, and erases" {
    run invocationMessage --message 'message: ' --clear all --success OK --fail FAILED true

    [ $status -eq 0 ]
    [ "$output" = "${S}message: OK${RE}" ]
}

@test "a failing command with clear appends the passed fail sigil, waits, and erases" {
    run invocationMessage --message 'message: ' --clear all --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "${S}message: FAILED${RE}" ]
}
