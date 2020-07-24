#!/usr/bin/env bats

load fixture

setup() {
    printf > "${BATS_TMPDIR}/delays.txt" '%s\n' 1595604{200.0,200.5,201.0,201.5,202.0,202.5,203.0,203.5,204.0,204.5,205.0,205.5,206.0,206.5,207.0,207.5,208.0,208.5,209.0,209.5}00000000
}

delayer() {
    sed -i -e '1w /dev/stdout' -e 1d -- "${BATS_TMPDIR}/delays.txt"
}
export -f delayer
export BATS_TMPDIR DATE=delayer

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
