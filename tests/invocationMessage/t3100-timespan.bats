#!/usr/bin/env bats

load fixture
load delayer

@test "multi-line error from the command prints every second one including the last because of timespan" {
    run invocationMessage --message 'message: ' --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}5" ]
}

@test "multi-line error from the command prints every third one not including the last because of timespan" {
    run invocationMessage --message 'message: ' --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}4${RESTORE_CURSOR_POSITION}${ERASE_TO_END}7" ]
}

@test "multi-line error from the command prints every second one including the last and sigil" {
    run invocationMessage --message 'message: ' --success OK --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}5${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "multi-line error from the command prints every third one not including the last and sigil" {
    run invocationMessage --message 'message: ' --success OK --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}4${RESTORE_CURSOR_POSITION}${ERASE_TO_END}7${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK" ]
}

@test "multi-line error from the command prints every second one including the last and then clears" {
    run invocationMessage --message 'message: ' --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 5${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command prints every third one not including the last and then clears" {
    run invocationMessage --message 'message: ' --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 4${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 7${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command prints every second one including the last and sigil and then clears" {
    run invocationMessage --message 'message: ' --success OK --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 3${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 5${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command prints every third one not including the last and sigil and then clears" {
    run invocationMessage --message 'message: ' --success OK --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: 1${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 4${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: 7${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
