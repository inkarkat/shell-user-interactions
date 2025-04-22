#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../timer

@test "duration and error output power a timer" {
    run invocationTimer --message 'message: ' --command "$MULTI_LINE_COMMAND"

    assert_success || echo "$status-$output" | failThis prefix \# >&3
    [[ "$output" =~ ^"message: 1s2s${E}3s${E}4s${E}5s${E}6s${E}"("7s${E}")?"first
second
third
fourth
fifth"$ ]] || dump_output
}

@test "duration and error output power a timer and then prints the sigil" {
    run invocationTimer --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    assert_success || echo "$status-$output" | failThis prefix \# >&3

    [[ "$output" =~ ^"message: 1s2s${E}3s${E}4s${E}5s${E}6s${E}"("7s${E}")?"${E}OK ("[67]"s)first
second
third
fourth
fifth"$ ]] || dump_output
}
