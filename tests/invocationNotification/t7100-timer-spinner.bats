#!/usr/bin/env bats

load fixture
load overlay
load timer

@test "print duration every two seconds and error output powers a spinner" {
    run invocationNotification --to overlay --message 'message: ' --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: /${N}${R}message: "(\(1s\)\ )?"-${N}${R}message: ("[12]"s) \\${N}${R}message: ("[234]"s) |${N}${R}message: ("[345]"s) |${N}${R}message: ("[56]"s) /${N}${R}message: ("[56]"s) -${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: /${N}${R}message: "(\(1s\)\ )?"-${N}${R}message: ("[12]"s) \\${N}${R}message: ("[234]"s) |${N}${R}message: ("[345]"s) |${N}${R}message: ("[56]"s) /${N}${R}message: ("[56]"s) -${N}${R}message: OK ("[67]"s)${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationNotification --to overlay --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: ("[23]"s) /${N}${R}message: ("[45]"s) /${N}${R}message: ("[45]"s) /${N}${R}message: ("[56]"s) -${N}"("${R}message: (6s) \\${N}")?"${R}message: OK ("[67]"s)${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "timer and then spin" {
    run invocationNotification --to overlay --timespan 0 --spinner-stderr --timer 2 --success YES -m 'just a test: ' -c "$SLEEP_OUT_ERR_OUT"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}just a test: ${N}${R}just a test: (2s) /${N}one
"("${R}just a test: (4s) /${N}")?"two
"("${R}just a test: (4s) /${N}")?"three
"("${R}just a test: (6s) /${N}")?"four
"("${R}just a test: ("[678]"s) /${N}"){0,2}"${R}just a test: ("[789]"s) -${N}${R}just a test: ("[89]"s) \\${N}${R}just a test: (1"[01]"s) \\${N}five
"("${R}just a test: (12s)|${N}")?"six
"("${R}just a test: (1"[23]"s) |${N}")?"seven
"("${R}just a test: (1"[45]"s) |${N}")?"${R}just a test: YES (1"[45]"s)${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
