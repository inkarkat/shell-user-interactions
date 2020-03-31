#!/usr/bin/env bats

load fixture

@test "clearing an unknown ID causes an error and returns 4" {
    run durationMessage --id doesNotExist --clear
    [ $status -eq 4 ]
    [ "$output" = 'ERROR: ID "doesNotExist" not found.' ]
}

@test "clearing a known ID without a previous message succeeds" {
    durationMessage --id ID --initial

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = "" ]
}
