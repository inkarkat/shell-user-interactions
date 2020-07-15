#!/usr/bin/env bats

load fixture
load overlay

@test "a successful command with clear all erases" {
    run invocationNotification --to overlay --message 'message: ' --clear all true

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${C}" ]
}

@test "a successful command with clear success erases" {
    run invocationNotification --to overlay --message 'message: ' --clear success true

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${C}" ]
}

@test "a successful command with clear failure does not erase" {
    run invocationNotification --to overlay --message 'message: ' --clear failure true

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}" ]
}

@test "a failing command with clear all erases" {
    run invocationNotification --to overlay --message 'message: ' --clear all false

    [ $status -eq 1 ]
    [ "$output" = "${R}message: ${N}${C}" ]
}

@test "a failing command with clear failure erases" {
    run invocationNotification --to overlay --message 'message: ' --clear failure false

    [ $status -eq 1 ]
    [ "$output" = "${R}message: ${N}${C}" ]
}

@test "a failing command with clear success does not erase" {
    run invocationNotification --to overlay --message 'message: ' --clear success false

    [ $status -eq 1 ]
    [ "$output" = "${R}message: ${N}" ]
}
