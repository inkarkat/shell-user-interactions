#!/usr/bin/env bats

export INVOCATIONMESSAGE_SINK=/dev/null
export MIXED_COMMAND='echo stdout; echo >&2 stderr; echo stdout again; echo >&2 stderr again'

@test "capture stdout output from a mixed command" {
    output="$(invocationMessage --message 'message: ' --success OK --command "$MIXED_COMMAND")"
    [ "$output" = "stdout
stdout again" ]
}

@test "suppress stdout and capture stderr output from a mixed command" {
    output="$(invocationMessage --message 'message: ' --success OK --command "$MIXED_COMMAND" 2>&1 >/dev/null)"
    [ "$output" = "stderr
stderr again" ]
}

@test "capture stdout and stderr output from a mixed command" {
    output="$(invocationMessage --message 'message: ' --success OK --command "$MIXED_COMMAND" 2>&1)"
    [ "$output" = "stdout
stdout again
stderr
stderr again" ]
}

