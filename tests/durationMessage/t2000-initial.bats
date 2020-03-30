#!/usr/bin/env bats

load fixture

@test "initial call without message does nothing" {
    durationMessage --id ID --initial
}

@test "initial call with message prints it" {
    run durationMessage --id ID --initial --message 'testing it'
    [ $status -eq 0 ]
    [ "$output" = 'testing it' ]
}

@test "initial call to unavailable sink returns 1 and omits the error" {
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --initial --message 'testing it'
    [ $status -eq 1 ]
    [ "$output" = '' ]
}
