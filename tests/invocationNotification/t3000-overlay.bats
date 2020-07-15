#!/usr/bin/env bats

load fixture
load overlay

@test "echo prints the message" {
    run invocationNotification --to overlay --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}executed" ]
}

@test "printf with clear prints and then erases the message" {
    run invocationNotification --to overlay --message 'message: ' --clear all printf executed

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}executed${C}" ]
}

@test "echo with clear prints and then erases the message" {
    run invocationNotification --to overlay --message 'message: ' --clear all echo executed

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}executed
${C}" ]
}

@test "echo with clear does not delay" {
    assertNoDelay invocationNotification --to overlay --message 'message: ' --clear all echo executed
}
