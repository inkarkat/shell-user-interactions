#!/usr/bin/env bats

load fixture
export NO_OUTPUT="message: "

@test "a simple failing false returns its exit status" {
    run invocationMessage --message 'message: ' false

    [ $status -eq 1 ]
    [ "$output" = "$NO_OUTPUT" ]
}

@test "an exec'd failing false returns its exit status" {
    run invocationMessage --message 'message: ' exec false

    [ $status -eq 1 ]
    [ "$output" = "$NO_OUTPUT" ]
}

@test "an exit command returns its exit status" {
    run invocationMessage --message 'message: ' exit 42

    [ $status -eq 42 ]
    [ "$output" = "$NO_OUTPUT" ]
}
