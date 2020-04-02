#!/usr/bin/env bats

load fixture
load marker

@test "updating with command that returns non-zero exit status returns that status and restores the message afterwards" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --update --command '(exit 42)'

    [ $status -eq 42 ]
    [ "$output" = "${CLR}testing it" ]
}

@test "updating with unavailable sink returns 1 and does not invoke the command" {
    durationMessage --id ID --initial --message 'testing it'

    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update "${APPEND_COMMAND_ARGUMENTS[@]}" "$MARKER"
    [ $status -eq 1 ]
    [ "$output" = "" ]
    assert_marker_calls -eq 0
}

@test "updating with unavailable sink returns 1 two times, third updating replaces original message" {
    durationMessage --id ID --initial --message 'testing it'

    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update echo 'command output'
    [ $status -eq 1 ]
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update echo 'command output'
    [ $status -eq 1 ]

    run durationMessage --id ID --update echo 'command output'

    [ $status -eq 0 ]
    [ "$output" = "${CLR}command output
testing it" ]
}
