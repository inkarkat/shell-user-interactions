#!/usr/bin/env bats

load fixture

export SINGLE_LINE_COMMAND='echo from command >&2'
export MULTI_LINE_COMMAND='{ echo from command; echo more from command; } >&2'

@test "single-line error from the command is individually appended to the message after the command concludes" {
    run invocationMessage --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command" ]
}

@test "multi-line error from the command is individually appended to the message after the command concludes" {
    run invocationMessage --message 'message: ' --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}more from command" ]
}

@test "single-line error from the command is individually appended to the message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "multi-line error from the command is individually appended to the message and sigil after the command concludes" {
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
