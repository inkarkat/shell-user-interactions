#!/usr/bin/env bats

load fixture

@test "printf prints the message" {
    run invocationMessage --message 'message: ' printf executed

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: executed${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "echo prints the message" {
    run invocationMessage --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: executed
${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
