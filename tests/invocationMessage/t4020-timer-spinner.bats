#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and error output powers a spinner" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "${output//[34]/X}" = "message: /-\\${SAVE_CURSOR_POSITION}(Xs) third |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fourth |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fifth |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) | " ]
}

@test "print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    output="${output//[34]/X}"
    output="${output//[67]/Y}"
    [ "$output" = "message: /-\\${SAVE_CURSOR_POSITION}(Xs) third |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fourth |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) fifth |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (Ys)" ]
}

@test "first print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}(2s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fourth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fifth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ]
}
