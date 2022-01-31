#!/usr/bin/env bats

export INVOCATIONNOTIFICATION_SINK=/dev/null

@test "a simple failing false returns its exit status" {
    run invocationNotification --to overlay --message 'message: ' false

    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "an exec'd failing false returns its exit status" {
    run invocationNotification --to overlay --message 'message: ' exec false

    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "an exit command returns its exit status" {
    run invocationNotification --to overlay --message 'message: ' exit 42

    [ $status -eq 42 ]
    [ "$output" = "" ]
}
