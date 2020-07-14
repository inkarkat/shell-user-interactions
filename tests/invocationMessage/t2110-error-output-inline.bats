#!/usr/bin/env bats

load fixture

@test "single-line error from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command" ]
}

@test "multi-line error from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}more from command" ]
}

@test "single-line error from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}more from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "single-line error from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --inline-stderr --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --inline-stderr --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: more from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "single-line error from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: more from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error that contains the statusline marker is not individually appended" {
    run invocationMessage --message 'message: ' --inline-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}first${RESTORE_CURSOR_POSITION}${ERASE_TO_END}last" ]
}
