#!/usr/bin/env bats

load fixture

@test "echo prints the message" {
    run invocationMessage --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "message: executed" ]
}

@test "printf with clear prints and then erases the message" {
    run invocationMessage --message 'message: ' --clear all printf executed

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: executed${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "echo with clear prints and then erases the message" {
    run invocationMessage --message 'message: ' --clear all echo executed

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: executed
${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "echo with clear does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --clear all echo executed
}