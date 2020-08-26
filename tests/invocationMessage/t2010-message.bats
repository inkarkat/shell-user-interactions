#!/usr/bin/env bats

load fixture

@test "echo prints the message" {
    run invocationMessage --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "message: executed" ]
}

@test "printf with clear prints and then erases the message" {
    run invocationMessage --message 'message: ' --clear all printf executed

    [ $status -eq 0 ]
    [ "$output" = "${S}message: executed${RE}" ]
}

@test "echo with clear prints and then erases the message" {
    run invocationMessage --message 'message: ' --clear all echo executed

    [ $status -eq 0 ]
    [ "$output" = "${S}message: executed
${RE}" ]
}

@test "echo with clear does not delay" {
    assertNoDelay invocationMessage --message 'message: ' --clear all echo executed
}
