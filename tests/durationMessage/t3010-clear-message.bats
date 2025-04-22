#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

@test "clearing a known ID clears a previous message" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run -0 durationMessage --id ID --inline-always --clear
    assert_control_output "${MESSAGE//?/}${CLR}"
}

@test "clearing a known ID without inline outputs nothing" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run -0 durationMessage --id ID --clear
    assert_control_output ''
}

@test "clearing again does not output anything" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    durationMessage --id ID --clear

    run -0 durationMessage --id ID --inline-always --clear
    assert_control_output ''
}

@test "clearing with unavailable sink returns 1, next clearing will output" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --inline-always --clear

    run -0 durationMessage --id ID --inline-always --clear
    assert_control_output "${MESSAGE//?/}${CLR}"
}

@test "clearing with unavailable sink without inline succeeds because nothing is output" {
    durationMessage --id ID --initial --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -0 durationMessage --id ID --clear
}
