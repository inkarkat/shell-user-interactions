#!/usr/bin/env bats

load fixture
load marker

MESSAGE='testing it'
COMMAND_OUTPUT='command output'

@test "updating with command that returns non-zero exit status returns that status and restores the message afterwards" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run durationMessage --id ID --update --command '(exit 42)'

    [ $status -eq 42 ]
    [ "$output" = "${MESSAGE//?/}${CLR}${MESSAGE}" ]
}

@test "updating with unavailable sink returns 1 and does not invoke the command" {
    durationMessage --id ID --initial --message "$MESSAGE"

    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update "${APPEND_COMMAND_ARGUMENTS[@]}" "$MARKER"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    assert_marker_calls -eq 0
}

@test "updating with unavailable sink returns 1 two times, third updating replaces original message" {
    durationMessage --id ID --initial --message "$MESSAGE"

    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    [ $status -eq 1 ]
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    [ $status -eq 1 ]

    run durationMessage --id ID --update echo "$COMMAND_OUTPUT"

    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}${COMMAND_OUTPUT}
${MESSAGE}" ]
}
