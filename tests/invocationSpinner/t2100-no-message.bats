#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../timer

@test "spinner with message every second" {
    run -0 invocationSpinner --message 'message: ' sleep 5
    [ "$output" = "message: /-\\|/ " ] || dump_output
}

@test "spinner with empty message prevents the synthesis and default clearing" {
    run -0 invocationSpinner --message '' sleep 5
    [ "$output" = "/-\\|/ " ] || dump_output
}

@test "spinner without message every second synthesizes the message from the simple command and clears at the end" {
    run -0 invocationSpinner sleep 5
    [ "$output" = "${S}sleep 5 /-\\|/${RE}" ] || dump_output
}

@test "spinner without message every second synthesizes the message from the commandline, no-clear option overrides the default clearing " {
    run -0 invocationSpinner --no-clear --command "true && sleep 5"
    [ "$output" = "true /-\\|/ " ] || dump_output
}

@test "spinner without message every second synthesizes the message, explicit clear parameter overrides the default clearing " {
    run -0 invocationSpinner --clear failure sleep 5
    [ "$output" = "${S}sleep 5 /-\\|/ " ] || dump_output
}
