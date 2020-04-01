#!/usr/bin/env bats

load fixture

@test "finishing an unknown ID causes an error and returns 4" {
    run durationMessage --id doesNotExist --finish
    [ $status -eq 4 ]
    [ "$output" = 'ERROR: ID "doesNotExist" not found.' ]
}

@test "finishing a known ID without a previous message succeeds" {
    durationMessage --id ID --initial

    run durationMessage --id ID --finish
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "finishing a known ID forgets the ID" {
    durationMessage --id ID --initial
    durationMessage --id ID --finish

    run durationMessage --id ID --clear
    [ $status -eq 4 ]
    [ "$output" = 'ERROR: ID "ID" not found.' ]
}

@test "finishing a known ID with a message that persists" {
    durationMessage --id ID --initial

    run durationMessage --id ID --finish --message "it's done"
    [ $status -eq 0 ]
    [ "$output" = "it's done" ]
}
