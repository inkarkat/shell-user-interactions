#!/usr/bin/env bats

load fixture

@test "clearing a known ID clears a previous message" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = "${CLR}" ]
}

@test "clearing again does not output anything" {
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --clear

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = '' ]
}

@test "clearing with unavailable sink returns 1, next clearing will output" {
    durationMessage --id ID --initial --message 'testing it'
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --clear
    [ $status -eq 1 ]

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = "${CLR}" ]
}
