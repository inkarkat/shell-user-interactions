#!/usr/bin/env bats

load fixture
export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=0
export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=0

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
    [ "$output" = "${SAVE_CURSOR_POSITION}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "a failing command with clear appends the passed fail sigil, waits, and erases" {
    run invocationMessage --message 'message: ' --clear all --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: FAILED${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
