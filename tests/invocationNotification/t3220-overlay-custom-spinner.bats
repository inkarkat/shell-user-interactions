#!/usr/bin/env bats

load overlay

@test "full spin cycle with custom 3-part application-specific spinner" {
    export INVOCATIONNOTIFICATION_SPINNER='ABC'
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: ${N}${R}message: A${N}${R}message: B${N}${R}message: C${N}${R}message: A${N}${R}message: B${N}${R}message: ${N}"
}

@test "full spin cycle with custom 2-part generic spinner" {
    export SPINNER='▌▐'
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: ${N}${R}message: ▌${N}${R}message: ▐${N}${R}message: ▌${N}${R}message: ▐${N}${R}message: ▌${N}${R}message: ${N}"
}
