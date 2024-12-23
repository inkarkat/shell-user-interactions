#!/usr/bin/env bats

load overlay

@test "full sweep cycle with custom 4-part application-specific sweeper" {
    export INVOCATIONNOTIFICATION_SWEEPS='___,A__,_A_,__A,_A_'
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: ${N}${R}message: A__${N}${R}message: _A_${N}${R}message: __A${N}${R}message: _A_${N}${R}message: A__${N}${R}message: ${N}"
}

@test "full sweep cycle with custom 2-part generic sweeper" {
    export SWEEPS='█|  ,█|- ,█|--,█| -,█|--'
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: ${N}${R}message: █|- ${N}${R}message: █|--${N}${R}message: █| -${N}${R}message: █|--${N}${R}message: █|- ${N}${R}message: ${N}"
}
