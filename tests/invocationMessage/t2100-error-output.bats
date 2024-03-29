#!/usr/bin/env bats

load fixture

@test "single-line error from the command is appended to the message after the command concludes" {
    run invocationMessage --message 'message: ' --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: from command" ]
}

@test "multi-line error from the command is appended to the message after a newline when stderr is to terminal" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message:${SP}
from command
more from command" ]
}

@test "multi-line error from the command is directly appended to the message when stderr is redirected" {
    run invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: from command
more from command" ]
}

@test "single-line error from the command is appended to the message and sigil separated by a semicolon when stderr is to terminal" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OK; from command" ]
}

@test "single-line error from the command is directly appended to the message and sigil when stderr is redirected" {
    run invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OKfrom command" ]
}

@test "multi-line error from the command is appended to the message and sigil when stderr is to terminal" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OK
from command
more from command" ]
}

@test "multi-line error from the command is appended to the message and sigil when stderr is redirected" {
    run invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OKfrom command
more from command" ]
}

@test "single-line error from the command is printed after the cleared message after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: ${RE}from command" ]
}

@test "multi-line error from the command is printed after the cleared message after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: ${RE}from command
more from command" ]
}

@test "single-line error from the command is printed after the cleared message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: OK${RE}from command" ]
}

@test "multi-line error from the command is printed after the cleared message and sigil after the command concludes" {
    run invocationMessage --message 'message: ' --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message: OK${RE}from command
more from command" ]
}

@test "a failing silent command returns its exit status" {
    NO_OUTPUT="message: "
    run invocationMessage --message "$NO_OUTPUT" false

    [ $status -eq 1 ]
    [ "$output" = "$NO_OUTPUT" ]
}
