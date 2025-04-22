#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

@test "finishing a known ID clears a previous message" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run -0 durationMessage --id ID --finish --inline-always
    assert_control_output "${MESSAGE//?/}${CLR}"
}

@test "finishing a known ID without inline outputs nothing" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run -0 durationMessage --id ID --finish
    assert_control_output ''
}

@test "finishing a known ID replaces a previous message with the passed one" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run -0 durationMessage --id ID --finish --inline-always --message 'we are done here now'
    assert_control_output "${MESSAGE//?/}${CLR}we are done here now"
}

@test "finishing a known ID without inline prints the passed one" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run -0 durationMessage --id ID --finish --message 'we are done here now'
    assert_control_output 'we are done here now'
}

@test "finishing with unavailable sink returns 1, next finishing will output" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --finish --inline-always

    run -0 durationMessage --id ID --finish --inline-always
    assert_control_output "${MESSAGE//?/}${CLR}"
}
@test "finishing with unavailable sink returns 1, next finishing will replace message" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --finish --inline-always --message 'we are not done yet'

    run -0 durationMessage --id ID --finish --inline-always --message 'we are done on second try'
    assert_control_output "${MESSAGE//?/}${CLR}we are done on second try"
}

@test "finishing with unavailable sink without inline returns 1, next finishing will print message" {
    durationMessage --id ID --initial --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --finish --message 'we are not done yet'

    run -0 durationMessage --id ID --finish --message 'we are done on second try'
    assert_control_output 'we are done on second try'
}
