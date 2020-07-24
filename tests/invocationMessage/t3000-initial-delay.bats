#!/usr/bin/env bats

load fixture
load delayer

@test "message is suppressed because an immediate command execution falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "message and sigil are suppressed because an immediate command execution falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --success OK --command true
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

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
