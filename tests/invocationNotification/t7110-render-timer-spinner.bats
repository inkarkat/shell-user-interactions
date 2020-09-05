#!/usr/bin/env bats

load fixture
load overlay
load timer

@test "duration and error output power a spinner" {
    run invocationNotification --to overlay --message 'message: ' --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "duration and error output power a spinner and then print sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: OK ("[67]"s)${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first duration and error output power a spinner and then print sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: /${N}${R}message: OK (7s)${N}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
