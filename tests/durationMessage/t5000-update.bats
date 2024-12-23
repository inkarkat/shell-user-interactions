#!/usr/bin/env bats

load fixture

@test "updating an unknown ID causes an error and returns 4" {
    run -4 durationMessage --id doesNotExist --update
    assert_output 'ERROR: ID "doesNotExist" not found.'
}

@test "updating a known ID without a previous message succeeds" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --update
    assert_output ''
}

@test "updating a known ID without a previous message with a message" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --update --message 'first update'
    assert_output 'first update'
}
