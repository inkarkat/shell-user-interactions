#!/usr/bin/env bats

load fixture
load timer

@test "duration and error output power a spinner" {
    run invocationMessage --message 'message: ' --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "${output//[34]/X}" = "message: /-\\${SAVE_CURSOR_POSITION}third |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}fourth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}fifth -${RESTORE_CURSOR_POSITION}${ERASE_TO_END}\\ " ]
}

@test "duration and error output power a spinner and then print sigil" {
    run invocationMessage --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "${output//[67]/X}" = "message: /-\\${SAVE_CURSOR_POSITION}third |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}fourth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}fifth -${RESTORE_CURSOR_POSITION}${ERASE_TO_END}\\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (Xs)" ]
}

@test "first duration and error output power a spinner and then print sigil" {
    run invocationMessage --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}/${RESTORE_CURSOR_POSITION}${ERASE_TO_END}-${RESTORE_CURSOR_POSITION}${ERASE_TO_END}fourth \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}fifth |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}/${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ]
}
