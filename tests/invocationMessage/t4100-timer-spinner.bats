#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and error output powers a spinner" {
    run -0 invocationMessage --message 'message: ' --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: "(1s\ /1s\ "${E}"-|/-[12]s\ |/[1]s\ -[12]s\ "${E}")"\\"[234]"s ${E}|"[345]"s ${E}|"[56]"s ${E}/"[56]"s ${E}- "$ ]] || dump_output
}

@test "print duration every two seconds and error output powers a spinner and then sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: "(1s\ /1s\ "${E}"-|/-[12]s\ |/[1]s\ -[12]s\ "${E}")"\\"[234]"s ${E}|"[345]"s ${E}|"[56]"s ${E}/"[56]"s ${E}-${E}OK ("[67]"s)"$ ]] || dump_output
}

@test "first print duration every two seconds and error output powers a spinner and then sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"
    [[ "$output" =~ ^"message: "[23]"s /"[45]"s ${E}/"[45]"s ${E}/"[56]"s ${E}-"("6s ${E}\\")?"${E}OK ("[67]"s)"$ ]]  || dump_output
}

@test "timer and then spin" {
    run -0 invocationMessage --timespan 0 --spinner-stderr --timer 2 --success YES -m 'just a test: ' -c "$SLEEP_OUT_ERR_OUT"
    [[ "$output" =~ ^"just a test: 2s /one
"("4s ${E}/")?"two
"("4s ${E}/")?"three
"("6s ${E}/")?"four
"("6s ${E}/")?"7s ${E}/8s ${E}-8s ${E}\\10s ${E}\\five
"("12s ${E}|")?"six
"("12s ${E}|")?"seven
"("14s ${E}|")?"${E}YES (14s)"$ ]] || dump_output
}
