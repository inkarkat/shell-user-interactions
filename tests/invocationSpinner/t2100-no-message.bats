#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "spinner with message every second" {
    run invocationSpinner --message 'message: ' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: /-\\|/ " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "spinner without message every second clears at the end" {
    run invocationSpinner sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}/-\\|/${RE}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
