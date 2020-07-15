#!/usr/bin/env bats

load fixture
load overlay

@test "multi-line error from the command is printed after creating and before clearing the overlay" {
    run invocationNotification --to overlay --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}from command
more from command
${C}" ]
}
