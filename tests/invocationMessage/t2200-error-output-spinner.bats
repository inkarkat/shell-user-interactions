#!/usr/bin/env bats

load fixture

@test "single-line error from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --spinner-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: / " ]
}

@test "multi-line error from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /- " ]
}

@test "errors powering full spin cycle" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'

    [ $status -eq 0 ]
    [ "$output" = "message: /-\\|/ " ]
}

@test "single-line error from the command powers a spinner after the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --spinner-stderr --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /OK" ]
}

@test "multi-line error from the command powers a spinner after the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-OK" ]
}

@test "single-line error from the command powers a spinner and then cleared" {
    run invocationMessage --message 'message: ' --spinner-stderr --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: /${RE}" ]
}

@test "multi-line error from the command powers a spinner and then cleared" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: /-${RE}" ]
}

@test "single-line error from the command powers a spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --spinner-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: /OK${RE}" ]
}

@test "multi-line error from the command powers a spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: /-OK${RE}" ]
}

@test "multi-line error that contains the statusline marker does not rotate the spinner" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'

    [ $status -eq 0 ]
    [ "$output" = "message: /- " ]
}

@test "a failing silent command with --spinner-stderr returns its exit status" {
    NO_OUTPUT="message: "
    run invocationMessage --message "$NO_OUTPUT" --timespan 0 --spinner-stderr false

    [ $status -eq 1 ]
    [ "$output" = "$NO_OUTPUT" ]
}
