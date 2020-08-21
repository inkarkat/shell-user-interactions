#!/usr/bin/env bats

load fixture

@test "print duration every two seconds" {
    run invocationMessage --message 'message: ' --timer 2 sleep 5

    echo "$output" | trcontrols | prefix \# >&3
    [ $status -eq 0 ]
    [ "$output" = "message: 24${ERASE_TO_END}" ]
}
