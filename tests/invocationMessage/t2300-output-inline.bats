#!/usr/bin/env bats

load fixture

@test "single-line output from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --inline --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
${SAVE_CURSOR_POSITION}stdout" ]
}

@test "multi-line output from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --inline --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
stdout again
${SAVE_CURSOR_POSITION}stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stderr again" ]
}

@test "single-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --inline --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
${SAVE_CURSOR_POSITION}stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "multi-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --inline --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
stdout again
${SAVE_CURSOR_POSITION}stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "single-line output from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --inline --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line output from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --inline --clear all --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
stdout again
stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "single-line output from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line output from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline --clear all --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
stdout again
stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
