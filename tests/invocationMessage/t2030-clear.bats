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
