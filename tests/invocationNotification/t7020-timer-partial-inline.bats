#!/usr/bin/env bats

load overlay

@test "print duration when incomplete lines are printed slowly" {
    run -0 invocationNotification --to overlay --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "{ printf first.; sleep 0.5; printf second.; sleep 0.8; printf third.; sleep 4.8; echo fourth; sleep 1.8; printf A; sleep 2.5; printf B; sleep 2.5; printf C; } >&2"
    [[ "$output" =~ ^"${R}message: ${N}${R}message: ("[34]"s) ${N}${R}message: ("[56]"s) ${N}${R}message: ("[567]"s) first.second.third.fourth${N}${R}message: ("(9|10|11)"s) first.second.third.fourth${N}${R}message: ("1[23]"s) first.second.third.fourth${N}${R}message: ("1[23]"s) ABC${N}"$ ]] || dump_output
}
