#!/usr/bin/env bats

load fixture

@test "single-line output from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --spinner --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
/ " ]
}

@test "multi-line output from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --spinner --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
stdout again
/- " ]
}

@test "full spin cycle" {
    run invocationMessage --message 'message: ' --spinner --command 'seq 1 5'

    [ $status -eq 0 ]
    [ "$output" = "message: 1
2
3
4
5
/-\\|/ " ]
}

@test "single-line output from the command powers a spinner after the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --spinner --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
/OK" ]
}

@test "multi-line output from the command powers a spinner after the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --spinner --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: stdout
stdout again
/-OK" ]
}

@test "single-line output from the command powers a spinner and then cleared" {
    run invocationMessage --message 'message: ' --spinner --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
/${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line output from the command powers a spinner and then cleared" {
    run invocationMessage --message 'message: ' --spinner --clear all --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
stdout again
/-${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "single-line output from the command powers a spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --spinner --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
/OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line output from the command powers a spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --spinner --clear all --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: stdout
stdout again
/-OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
