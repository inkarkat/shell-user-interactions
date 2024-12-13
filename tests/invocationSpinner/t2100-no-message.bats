#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "spinner with message every second" {
    run invocationSpinner --message 'message: ' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: /-\\|/ " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "spinner with empty message prevents the synthesis and default clearing" {
    run invocationSpinner --message '' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "/-\\|/ " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "spinner without message every second synthesizes the message from the simple command and clears at the end" {
    run invocationSpinner sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}sleep 5 /-\\|/${RE}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "spinner without message every second synthesizes the message from the commandline, no-clear option overrides the default clearing " {
    run invocationSpinner --no-clear --command "true && sleep 5"

    [ $status -eq 0 ]
    [ "$output" = "true /-\\|/ " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "spinner without message every second synthesizes the message, explicit clear parameter overrides the default clearing " {
    run invocationSpinner --clear failure sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}sleep 5 /-\\|/ " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
