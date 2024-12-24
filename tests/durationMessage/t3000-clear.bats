#!/usr/bin/env bats

load fixture

@test "clearing an unknown ID causes an error and returns 4" {
    run -4 durationMessage --id doesNotExist --clear
    assert_output 'ERROR: ID "doesNotExist" not found.'
}

@test "clearing a known ID without a previous message succeeds" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --clear
    assert_output ''
}
