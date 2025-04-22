#!/usr/bin/env bats

load overlay

@test "full sweep cycle" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: [ -* ]${N}${R}message: [  -*]${N}${R}message: [   *]${N}${R}message: [  *-]${N}${R}message: [ *- ]${N}${R}message: [*-  ]${N}${R}message: [*   ]${N}${R}message: ${N}"
}
