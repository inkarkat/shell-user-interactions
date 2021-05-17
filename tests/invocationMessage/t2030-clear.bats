#!/usr/bin/env bats

load fixture

@test "a successful command with clear all erases" {
    run invocationMessage --message 'message: ' --clear all true

    [ $status -eq 0 ]
    [ "$output" = "${S}message: ${RE}" ]
}

@test "a successful command with clear success erases" {
    run invocationMessage --message 'message: ' --clear success true

    [ $status -eq 0 ]
    [ "$output" = "${S}message: ${RE}" ]
}

@test "a successful command with clear failure does not erase" {
    run invocationMessage --message 'message: ' --clear failure true

    [ $status -eq 0 ]
    [ "$output" = "${S}message: " ]
}

@test "a successful silent command with clear no-error-output erases" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --clear no-error-output true

    [ $status -eq 0 ]
    [ "$output" = "${S}message: ${RE}" ]
}

@test "a successful outputting command with clear no-error-output does not erase" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --clear no-error-output --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${S}message:${SP}
from command
more from command" ]
}

@test "a failing command with clear all erases" {
    run invocationMessage --message 'message: ' --clear all false

    [ $status -eq 1 ]
    [ "$output" = "${S}message: ${RE}" ]
}

@test "a failing command with clear failure erases" {
    run invocationMessage --message 'message: ' --clear failure false

    [ $status -eq 1 ]
    [ "$output" = "${S}message: ${RE}" ]
}

@test "a failing command with clear success does not erase" {
    run invocationMessage --message 'message: ' --clear success false

    [ $status -eq 1 ]
    [ "$output" = "${S}message: " ]
}

@test "a failing silent command with clear no-error-output erases" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --clear no-error-output false

    [ $status -eq 1 ]
    [ "$output" = "${S}message: ${RE}" ]
}

@test "a failing outputting command with clear no-error-output does not erase" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run invocationMessage --message 'message: ' --clear no-error-output --command "$MULTI_LINE_COMMAND" --command false

    [ $status -eq 1 ]
    [ "$output" = "${S}message:${SP}
from command
more from command" ]
}
