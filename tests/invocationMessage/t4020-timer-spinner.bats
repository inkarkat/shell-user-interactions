#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and error output powers a spinner" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /"(-[12]s\ |[1]s\ -[12]s\ "${ERASE_TO_END}")"\\"[234]"s ${ERASE_TO_END}|"[345]"s ${ERASE_TO_END}/"[56]"s ${ERASE_TO_END}-"[56]"s ${ERASE_TO_END}\\ "$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /"(-[12]s\ |[1]s\ -[12]s\ "${ERASE_TO_END}")"\\"[234]"s ${ERASE_TO_END}|"[345]"s ${ERASE_TO_END}/"[56]"s ${ERASE_TO_END}-"[56]"s ${ERASE_TO_END}\\${ERASE_TO_END}OK ("[67]"s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and error output powers a spinner and then sigil" {
skip
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}(2s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fourth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fifth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ]
}

@test "timer and then spin" {
skip
    run invocationMessage --timespan 0 --spinner-stderr --timer 2 --success YES -m 'just a test: ' -c '{ sleep 3; echo one; sleep 1; echo two; sleep 1; echo three; sleep 1; echo four; sleep 1; echo >&2 X1; sleep 1; echo >&2 X2 ; sleep 1; echo >&2 X3; sleep 1; echo >&2 X4; sleep 1; echo five; sleep 1; echo six; sleep 1; echo seven; sleep 1; }'

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}(2s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fourth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fifth /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ]
}
