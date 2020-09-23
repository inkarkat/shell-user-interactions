#!/usr/bin/env bats

load fixture
load timer

@test "duration and output power a spinner" {
    run invocationMessage --message 'message: ' --spinner --timespan 0 --render-timer 1 --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-\|/-\|/ first
second
third
fourth
fifth" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
