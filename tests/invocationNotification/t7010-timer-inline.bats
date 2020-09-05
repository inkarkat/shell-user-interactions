#!/usr/bin/env bats

load fixture
load overlay
load timer

@test "print duration every two seconds and error output inline" {
    run invocationNotification --to overlay --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: first${N}${R}message: "(\(1s\)\ )?"second${N}${R}message: "(\([12]s\)\ )?"third${N}${R}message: ("[34]"s) third${N}${R}message: ("[45]"s) fourth${N}${R}message: ("[56]"s) fifth${N}${R}message: ("[56]"s) ${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and error output inline and then sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: first${N}${R}message: "(\(1s\)\ )?"second${N}${R}message: "(\([12]s\)\ )?"third${N}${R}message: ("[34]"s) third${N}${R}message: ("[45]"s) fourth${N}${R}message: ("[56]"s) fifth${N}${R}message: ("[56]"s) ${N}${R}message: OK ("[567]"s)${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and error output inline and then sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: (2s) ${N}${R}message: (4s) ${N}${R}message: ("[45]"s) fourth${N}${R}message: ("[56]"s) fifth${N}"("${R}message: (6s) ${N}")?"${R}message: OK (7s)${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
