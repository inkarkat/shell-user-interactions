#!/usr/bin/env bats

load fixture
load overlay

@test "full sweep cycle" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 9 >&2'

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: [ -* ]${N}${R}message: [  -*]${N}${R}message: [   *]${N}${R}message: [  *-]${N}${R}message: [ *- ]${N}${R}message: [*-  ]${N}${R}message: [*   ]${N}" ]
}
