#!/usr/bin/env bats

load fixture
load overlay

@test "full spin cycle with custom 3-part application-specific spinner" {
    export INVOCATIONNOTIFICATION_SPINNER='ABC'
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: A${N}${R}message: B${N}${R}message: C${N}${R}message: A${N}${R}message: B${N}${R}message: ${N}" ]
}

@test "full spin cycle with custom 2-part generic spinner" {
    export SPINNER='▌▐'
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: ▌${N}${R}message: ▐${N}${R}message: ▌${N}${R}message: ▐${N}${R}message: ▌${N}${R}message: ${N}" ]
}
