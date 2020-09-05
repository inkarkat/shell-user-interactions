#!/usr/bin/env bats

load fixture
load overlay
load inline-sink

@test "multi-line output from the command is individually appended / error output sweeps and final sigil" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr-inline --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: [ -* ] stdout${N}${R}message: [  -*] stdout again${N}${R}message: OK${N}"
}
