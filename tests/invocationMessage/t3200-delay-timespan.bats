#!/usr/bin/env bats

load fixture
load delayer

@test "single-line error from the command is suppressed because it falls within the initial delay that is larger than timespan" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 1000ms --inline-stderr --command "$SINGLE_LINE_COMMAND"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "two-line error from the command prints second line because it falls just within the initial delay that is larger than timespan" {
    run invocationMessage --message 'message: ' --initial-delay 1000ms --timespan 1000ms --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}2" ]
}

@test "multi-line error from the command prints third and then every second line" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}5${RESTORE_CURSOR_POSITION}${ERASE_TO_END}7${RESTORE_CURSOR_POSITION}${ERASE_TO_END}9" ]
}

@test "multi-line error from the command prints third and then every third line and then clears them" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 1500ms --inline-stderr --clear all --command 'seq 1 10 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 6${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 9${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command prints second and then every third line, then sigil, and then clears them" {
    run invocationMessage --message 'message: ' --initial-delay 750ms --timespan 1500ms --inline-stderr --success OK --clear all --command 'seq 1 8 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 2${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 5${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 8${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "large initial delay suppresses all output" {
    run invocationMessage --message 'message: ' --initial-delay 4501ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "large initial delay suppresses all but the final line" {
    run invocationMessage --message 'message: ' --initial-delay 4500ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}9" ]
}

@test "large initial delay suppresses all but the second-to-final line" {
    run invocationMessage --message 'message: ' --initial-delay 4000ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}8" ]
}
