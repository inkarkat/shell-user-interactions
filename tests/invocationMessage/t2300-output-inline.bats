#!/usr/bin/env bats

load fixture
load inline

@test "single-line output from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --inline --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${SAVE_CURSOR_POSITION}stdout"
}

@test "multi-line output from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "message: ${SAVE_CURSOR_POSITION}stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout again"
}

@test "multi-line output in different order from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "message: ${SAVE_CURSOR_POSITION}stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stderr again"
}

@test "single-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --inline --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${SAVE_CURSOR_POSITION}stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK"
}

@test "multi-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "message: ${SAVE_CURSOR_POSITION}stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK"
}

@test "single-line output from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --inline --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${SAVE_CURSOR_POSITION}message: stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "multi-line output from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --clear all --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "${SAVE_CURSOR_POSITION}message: stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stdout again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "single-line output from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${SAVE_CURSOR_POSITION}message: stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "multi-line output from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --clear all --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "${SAVE_CURSOR_POSITION}message: stderr${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stderr again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stdout${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stdout again${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}
