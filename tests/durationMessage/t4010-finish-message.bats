#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

@test "finishing a known ID clears a previous message" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run durationMessage --id ID --finish --inline-always
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}" ]
}

@test "finishing a known ID without inline outputs nothing" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run durationMessage --id ID --finish
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "finishing a known ID replaces a previous message with the passed one" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run durationMessage --id ID --finish --inline-always --message 'we are done here now'
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}we are done here now" ]
}

@test "finishing a known ID without inline prints the passed one" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run durationMessage --id ID --finish --message 'we are done here now'
    [ $status -eq 0 ]
    [ "$output" = "we are done here now" ]
}

@test "finishing with unavailable sink returns 1, next finishing will output" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --finish --inline-always
    [ $status -eq 1 ]

    run durationMessage --id ID --finish --inline-always
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}" ]
}
@test "finishing with unavailable sink returns 1, next finishing will replace message" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --finish --inline-always --message 'we are not done yet'
    [ $status -eq 1 ]

    run durationMessage --id ID --finish --inline-always --message 'we are done on second try'
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}we are done on second try" ]
}

@test "finishing with unavailable sink without inline returns 1, next finishing will print message" {
    durationMessage --id ID --initial --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --finish --message 'we are not done yet'
    [ $status -eq 1 ]

    run durationMessage --id ID --finish --message 'we are done on second try'
    [ $status -eq 0 ]
    [ "$output" = "we are done on second try" ]
}
