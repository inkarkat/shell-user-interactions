#!/usr/bin/env bats

load fixture
load inline
load newline
load delayer

@test "two-line error from the command prints second line with newline" {
    runWithFullOutput invocationMessage --message 'message: ' --initial-delay 1000ms --timespan 0 --inline-stderr --command 'seq 1 2 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}2
" ]
}
