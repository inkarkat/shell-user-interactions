#!/usr/bin/env bats

load fixture

@test "print duration when incomplete lines are printed slowly" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "{ printf first.; sleep 0.5; printf second.; sleep 0.8; printf third.; sleep 4.8; echo fourth; sleep 1.8; printf A; sleep 2.5; printf B; sleep 2.5; printf C; } >&2"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: ${SAVE_CURSOR_POSITION}("[34]"s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[56]"s) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("[56]"s) first.second.third.fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("(9|10|11)"s) first.second.third.fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("1[23]"s) first.second.third.fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}("1[23]"s) ABC"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
