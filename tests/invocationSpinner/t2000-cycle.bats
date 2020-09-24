#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "duration and error output power a spinner" {
    run invocationSpinner --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-\|/-\|/ first
second
third
fourth
fifth" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "duration and error output power a spinner and then prints the sigil" {
    run invocationSpinner --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /-\|/-\|/${E}OK ("[67]s")first
second
third
fourth
fifth"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
