#!/usr/bin/env bats

load fixture

export WS=$'\n[?7h'
export WE='[?7l'

@test "single-line error from the command is individually appended to the message with terminal wrapping off" {
    run invocationMessage --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${WE}message: ${S}from command${WS}" ]
}

@test "multi-line error from the command is individually appended to the message with terminal wrapping off" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${WE}message: ${S}from command${RE}more from command${WS}" ]
}

@test "an exit command still turns terminal wrapping back on" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-stderr exit 42

    [ $status -eq 42 ]
    [ "$output" = "${WE}message: ${WS}" ]
}
