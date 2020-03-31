#!/usr/bin/env bats

load fixture

@test "clearing a known ID clears a previous message" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = '' ]
}

@test "clearing again does not output anything" {
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --clear

    run durationMessage --id ID --clear
    [ $status -eq 0 ]
    [ "$output" = '' ]
}
