#!/usr/bin/env bats

load fixture
load inline
load delayer

@test "single-line error from the command is suppressed because it falls within the initial delay that is larger than timespan" {
    run invocationMessage --message 'message: ' --initial-delay 1001ms --timespan 1000ms --inline-stderr --command "$SINGLE_LINE_COMMAND"
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "two-line error from the command prints second line because it falls just within the initial delay that is larger than timespan" {
    run invocationMessage --message 'message: ' --initial-delay 1000ms --timespan 1000ms --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}2" ]
}

@test "multi-line error from the command prints third and then every second line" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}3${RE}5${RE}7${RE}9" ]
}

@test "multi-line error from the command prints third and then every third line and then clears them" {
    run invocationMessage --message 'message: ' --initial-delay 1250ms --timespan 1500ms --inline-stderr --clear all --command 'seq 1 10 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 3${RE}message: 6${RE}message: 9${RE}" ]
}

@test "multi-line error from the command prints second and then every third line, then sigil, and then clears them" {
    run invocationMessage --message 'message: ' --initial-delay 750ms --timespan 1500ms --inline-stderr --success OK --clear all --command 'seq 1 8 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 2${RE}message: 5${RE}message: 8${RE}message: OK${RE}" ]
}

@test "large initial delay suppresses all output" {
    run invocationMessage --message 'message: ' --initial-delay 4501ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "large initial delay suppresses all but the final line" {
    run invocationMessage --message 'message: ' --initial-delay 4500ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}9" ]
}

@test "large initial delay suppresses all but the second-to-final line" {
    run invocationMessage --message 'message: ' --initial-delay 4000ms --timespan 1000ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}8" ]
}
