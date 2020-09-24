#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "duration and error output power a timed spinner" {
    run invocationTimedSpinner --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /"(1s -[12]s "${E}"|-[12]s )"\\"[23]"s ${E}|"[34]"s ${E}/"[45]"s ${E}-"[56]"s ${E}\"[67]"s ${E}|"[67]"s ${E}/ first
second
third
fourth
fifth"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "duration and error output power a timed spinner and then prints the sigil" {
    run invocationTimedSpinner --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /"(1s -[12]s "${E}"|-[12]s )"\\"[23]"s ${E}|"[34]"s ${E}/"[45]"s ${E}-"[56]"s ${E}\"[67]"s ${E}|"[67]"s ${E}/${E}OK ("[67]s")first
second
third
fourth
fifth"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
