#!/usr/bin/env bats

load fixture
load ../timer

@test "duration and output power a spinner" {
    run -0 invocationMessage --message 'message: ' --spinner --timespan 0 --render-timer 1 --command "$MULTI_LINE_COMMAND"
    [ "$output" = "message: /-\|/-\|/ first
second
third
fourth
fifth" ] || dump_output
}
