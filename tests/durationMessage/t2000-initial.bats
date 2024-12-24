#!/usr/bin/env bats

load fixture

@test "initial call without message does nothing" {
    durationMessage --id ID --initial
}

@test "initial call with message prints it" {
    run -0 durationMessage --id ID --initial --message 'testing it'
    assert_output 'testing it'
}

@test "initial call to unavailable sink returns 1 and omits the error" {
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --initial --message 'testing it'
    assert_output ''
}
