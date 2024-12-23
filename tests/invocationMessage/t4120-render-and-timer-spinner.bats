#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and both duration and error output power a spinner" {
    run -0 invocationMessage --message 'message: ' --timer 2 --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: /"("1s -"[12]"s ${E}"|"-"[12]"s ")"\\"[234]"s ${E}|"[45]"s ${E}/"[56]"s ${E}-"[56]"s ${E}\\ "$ ]] || dump_output
}

@test "print duration every two seconds and both duration and error output power a spinner and then sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timer 2 --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: "("/"|"1s /")("1s "("${E}")?"-"[12]"s ${E}"|"-"[12]"s ")"\\"[234]"s ${E}|"[45]"s ${E}/"[56]"s ${E}-"[56]"s ${E}\\${E}OK (7s)"$ ]] || dump_output
}

@test "first print duration every two seconds and both duration and error output power a spinner and then sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timer 2 --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"
    [[ "$output" =~ ^"message: "[23]"s /"[45]"s ${E}-"[45]"s ${E}\\"[56]"s ${E}|"("6s ${E}/")?"${E}OK ("[67]"s)"$ ]]  || dump_output
}
