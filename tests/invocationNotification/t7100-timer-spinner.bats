#!/usr/bin/env bats

load overlay
load timer

@test "print duration every two seconds and error output powers a spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"${R}message: ${N}${R}message: "(\(1s\)\ )?"/${N}${R}message: "(\(1s\)\ )?"-${N}${R}message: ("[12]"s) \\${N}${R}message: ("[234]"s) |${N}${R}message: ("[345]"s) |${N}${R}message: ("[56]"s) /${N}${R}message: ("[56]"s) -${N}"$ ]] || dump_output
}

@test "print duration every two seconds and error output powers a spinner and then sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"${R}message: ${N}${R}message: /${N}${R}message: "(\(1s\)\ )?"-${N}${R}message: ("[12]"s) \\${N}${R}message: ("[234]"s) |${N}${R}message: ("[345]"s) |${N}${R}message: ("[56]"s) /${N}${R}message: ("[56]"s) -${N}${R}message: OK ("[67]"s)${N}"$ ]] || dump_output
}

@test "first print duration every two seconds and error output powers a spinner and then sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"
    [[ "$output" =~ ^"${R}message: ${N}${R}message: ("[23]"s) /${N}${R}message: ("[45]"s) /${N}${R}message: ("[45]"s) /${N}${R}message: ("[56]"s) -${N}"("${R}message: (6s) \\${N}")?"${R}message: OK ("[67]"s)${N}"$ ]] || dump_output
}

@test "timer and then spin" {
    run -0 invocationNotification --to overlay --timespan 0 --spinner-stderr --timer 2 --success YES -m 'just a test: ' -c "$SLEEP_OUT_ERR_OUT"
    [[ "$output" =~ ^"${R}just a test: ${N}${R}just a test: (2s) /${N}one
"("${R}just a test: (4s) /${N}"){0,2}"two
"("${R}just a test: (4s) /${N}"){0,2}"three
"("${R}just a test: (6s) /${N}"){0,2}"four
"("${R}just a test: ("[678]"s) /${N}"){0,2}"${R}just a test: ("[789]"s) -${N}${R}just a test: ("[89]"s) \\${N}${R}just a test: (1"[01]"s) \\${N}five
"("${R}just a test: (12s)|${N}"){0,2}"six
"("${R}just a test: (1"[23]"s) |${N}"){0,2}"seven
"("${R}just a test: (1"[45]"s) |${N}"){0,2}"${R}just a test: YES (1"[45]"s)${N}"$ ]] || dump_output
}
