#!/usr/bin/env bats

load fixture
export MULTI_LINE_COMMAND="{ echo first; sleep 0.5; echo second; sleep 0.8; echo third; sleep 2.8; echo fourth; sleep 1.8; echo fifth; sleep 1; } >&2"

@test "print duration every two seconds" {
    run invocationMessage --message 'message: ' --timer 2 sleep 5

    echo "$output" | trcontrols | prefix \# >&3
    [ $status -eq 0 ]
    [ "$output" = "message: 24${ERASE_TO_END}" ]
}

@test "print duration every two seconds, ignoring stderr" {
    run invocationMessage --message 'message: ' --timer 2 --command "$MULTI_LINE_COMMAND"

    echo "$output" | trcontrols | prefix \# >&3
    [ $status -eq 0 ]
    [ "$output" = "message: 36${ERASE_TO_END}first
second
third
fourth
fifth" ]
}
