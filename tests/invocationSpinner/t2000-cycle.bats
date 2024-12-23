#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "duration and error output power a spinner" {
    run -0 invocationSpinner --message 'message: ' --command "$MULTI_LINE_COMMAND"
    [ "$output" = "message: /-\|/-\|/ first
second
third
fourth
fifth" ] || dump_output
}

@test "duration and error output power a spinner and then prints the sigil" {
    run -0 invocationSpinner --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: /-\|/-\|/${E}OK ("[67]s")first
second
third
fourth
fifth"$ ]] || dump_output
}
