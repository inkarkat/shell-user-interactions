#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and both duration and error output power a spinner" {
    run invocationMessage --message 'message: ' --timer 2 --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /"("1s -"[12]"s ${E}"|"-"[12]"s ")"\\"[234]"s ${E}|"[45]"s ${E}/"[56]"s ${E}-"[56]"s ${E}\\ "$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and both duration and error output power a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "("/"|"1s /")("1s "("${E}")?"-"[12]"s ${E}"|"-"[12]"s ")"\\"[234]"s ${E}|"[45]"s ${E}/"[56]"s ${E}-"[56]"s ${E}\\${E}OK (7s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and both duration and error output power a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: 2s /4s ${E}-"[45]"s ${E}\\"[56]"s ${E}|"("6s ${E}/")?"${E}OK ("[67]"s)"$ ]]  || echo "$output" | trcontrols | failThis prefix \# >&3
}
