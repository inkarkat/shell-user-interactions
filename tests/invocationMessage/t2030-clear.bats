#!/usr/bin/env bats

load fixture

@test "a successful command with clear all erases" {
    run invocationMessage --message 'message: ' --clear all true

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "a successful command with clear success erases" {
    run invocationMessage --message 'message: ' --clear success true

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "a successful command with clear failure does not erase" {
    run invocationMessage --message 'message: ' --clear failure true

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: " ]
}

@test "a failing command with clear all erases" {
    run invocationMessage --message 'message: ' --clear all false

    [ $status -eq 1 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "a failing command with clear failure erases" {
    run invocationMessage --message 'message: ' --clear failure false

    [ $status -eq 1 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "a failing command with clear success does not erase" {
    run invocationMessage --message 'message: ' --clear success false

    [ $status -eq 1 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: " ]
}
