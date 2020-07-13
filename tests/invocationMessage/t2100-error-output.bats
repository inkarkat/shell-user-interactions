#!/usr/bin/env bats

load fixture
export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=0
export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=0

export SINGLE_LINE_COMMAND='echo from command >&2'
export MULTI_LINE_COMMAND='{ echo from command; echo more from command; } >&2'

@test "single-line error from the command is appended to the message after the command concludes" {
    run invocationMessage --message 'message: ' --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: from command" ]
}

@test "multi-line error from the command is appended to the message after the command concludes" {
    run invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: 
from command
more from command" ]
}

@test "single-line error from the command is appended to the message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OK; from command" ]
}

@test "multi-line error from the command is appended to the message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OK
from command
more from command" ]
}

@test "single-line error from the command is printed after the cleared message after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command" ]
}

@test "multi-line error from the command is printed after the cleared message after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command
more from command" ]
}

@test "single-line error from the command is printed after the cleared message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command" ]
}

@test "multi-line error from the command is printed after the cleared message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command
more from command" ]
}
