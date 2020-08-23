#!/usr/bin/env bats
shopt -qs extglob

load fixture

@test "print duration when incomplete lines are printed slowly" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "{ printf first.; sleep 0.5; printf second.; sleep 0.8; printf third.; sleep 4.8; echo fourth; sleep 1.8; printf A; sleep 2.5; printf B; sleep 2.5; printf C; } >&2"

    [ $status -eq 0 ]

    output="${output//@(9|10|11)/X}"
    output="${output//1[23]/Y}"
    output="${output//[34]/V}"
    output="${output//[56]/W}"
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}(Vs) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Ws) ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Ws) first.second.third.fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Xs) first.second.third.fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Ys) first.second.third.fourth${RESTORE_CURSOR_POSITION}${ERASE_TO_END}(Ys) ABC" ]
}
