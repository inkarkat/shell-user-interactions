#!/usr/bin/env bats

load fixture

@test "updating an unknown ID causes an error and returns 4" {
    run durationMessage --id doesNotExist --update
    [ $status -eq 4 ]
    [ "$output" = 'ERROR: ID "doesNotExist" not found.' ]
}

@test "updating a known ID without a previous message succeeds" {
    durationMessage --id ID --initial

    run durationMessage --id ID --update
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "updating a known ID without a previous message with a message" {
    durationMessage --id ID --initial

    run durationMessage --id ID --update --message 'first update'
    [ $status -eq 0 ]
    [ "$output" = 'first update' ]
}
