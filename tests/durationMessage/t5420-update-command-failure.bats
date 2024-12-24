#!/usr/bin/env bats

load marker

MESSAGE='testing it'
COMMAND_OUTPUT='command output'

@test "updating with command that returns non-zero exit status returns that status and restores the message afterwards" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run -42 durationMessage --id ID --update --inline-always --command '(exit 42)'
    assert_output "${MESSAGE//?/}${CLR}${MESSAGE}"
}

@test "updating with unavailable sink returns 1 and does not invoke the command" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --update --inline-always "${APPEND_COMMAND_ARGUMENTS[@]}" "$MARKER"
    assert_output ''
    assert_marker_calls -eq 0
}

@test "updating with unavailable sink returns 1 two times, third updating replaces original message" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --update --inline-always echo "$COMMAND_OUTPUT"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --update --inline-always echo "$COMMAND_OUTPUT"

    run -0 durationMessage --id ID --update --inline-always echo "$COMMAND_OUTPUT"
    assert_output - <<EOF
${MESSAGE//?/}${CLR}${COMMAND_OUTPUT}
${MESSAGE}
EOF
}
