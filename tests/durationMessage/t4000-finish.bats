#!/usr/bin/env bats

load fixture

@test "finishing an unknown ID causes an error and returns 4" {
    run -4 durationMessage --id doesNotExist --finish
    assert_output 'ERROR: ID "doesNotExist" not found.'
}

@test "finishing a known ID without a previous message succeeds" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --finish
    assert_output ''
}

@test "finishing a known ID forgets the ID" {
    durationMessage --id ID --initial
    durationMessage --id ID --finish

    run -4 durationMessage --id ID --clear
    assert_output 'ERROR: ID "ID" not found.'
}

@test "finishing a known ID with a message that persists" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --finish --message "it's done"
    assert_output "it's done"
}
