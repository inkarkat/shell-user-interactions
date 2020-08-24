#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and error output inline" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: ${SAVE_CURSOR_POSITION}first${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"(\(1s\)\ )?"second${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[12]"s) third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[34]"s) third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[45]"s) fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[56]"s) fifth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[56]"s) "$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and error output inline and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: ${SAVE_CURSOR_POSITION}first${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"(\(1s\)\ )?"second${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[12]"s) third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[34]"s) third${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[45]"s) fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[56]"s) fifth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[56]"s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK ("[567]"s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and error output inline and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}(2s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(4s) fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(6s) fifth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(6s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK (7s)" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
