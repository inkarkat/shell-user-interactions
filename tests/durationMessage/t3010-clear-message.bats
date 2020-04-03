#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

@test "clearing a known ID clears a previous message" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}" ]
}

@test "clearing again does not output anything" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = '' ]
}

@test "clearing with unavailable sink returns 1, next clearing will output" {
    durationMessage --id ID --initial --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --clear
    [ $status -eq 1 ]

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}" ]
}
