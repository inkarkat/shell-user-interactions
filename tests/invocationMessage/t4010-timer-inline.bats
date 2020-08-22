#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and error output inline" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "${output//[34]/X}" = "message: ${SAVE_CURSOR_POSITION}first${RESTORE_CURSOR_POSITION}${ERASE_TO_END}second${RESTORE_CURSOR_POSITION}${ERASE_TO_END}third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fifth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) " ]
}


@test "print duration every two seconds and error output inline and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "${output//[34]/X}" = "message: ${SAVE_CURSOR_POSITION}first${RESTORE_CURSOR_POSITION}${ERASE_TO_END}second${RESTORE_CURSOR_POSITION}${ERASE_TO_END}third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fifth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ]
}

@test "first print duration every two seconds and error output inline and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}(2s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fifth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ]
}
