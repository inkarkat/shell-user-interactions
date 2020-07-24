#!/usr/bin/env bats

load fixture
load delayer

@test "single-line error from the command is suppressed because it falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command "$SINGLE_LINE_COMMAND"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "two-line error from the command is suppressed because it falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "two-line error from the command prints second line because it falls just within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1000ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}2" ]
}

@test "multi-line error from the command prints third and subsequent lines" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}4${RESTORE_CURSOR_POSITION}${ERASE_TO_END}5" ]
}

@test "multi-line error from the command prints third and subsequent lines and then clears them" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --clear all --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 4${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 5${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
