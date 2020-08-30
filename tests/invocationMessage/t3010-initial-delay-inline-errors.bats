#!/usr/bin/env bats

load fixture
load inline
load delayer

@test "single-line error from the command is suppressed because it falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command "$SINGLE_LINE_COMMAND"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "two-line error from the command is suppressed because it falls within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "two-line error from the command prints second line because it falls just within the initial delay" {
    run invocationMessage --message 'message: ' --initial-delay 1000ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}2" ]
}

@test "multi-line error from the command prints third and subsequent lines" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}3${RE}4${RE}5" ]
}

@test "multi-line error from the command prints third and subsequent lines and then clears them" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 0 --inline-stderr --clear all --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 3${RE}message: 4${RE}message: 5${RE}" ]
}
