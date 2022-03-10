#!/usr/bin/env bats

load fixture
load overlay

@test "full sweep cycle with custom 4-part application-specific sweeper" {
    export INVOCATIONNOTIFICATION_SWEEPS='___,A__,_A_,__A,_A_'
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 5 >&2'

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: A__${N}${R}message: _A_${N}${R}message: __A${N}${R}message: _A_${N}${R}message: A__${N}${R}message: ${N}" ]
}

@test "full sweep cycle with custom 2-part generic sweeper" {
    export SWEEPS='█|  ,█|- ,█|--,█| -,█|--'
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 5 >&2'

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: █|- ${N}${R}message: █|--${N}${R}message: █| -${N}${R}message: █|--${N}${R}message: █|- ${N}${R}message: ${N}" ]
}
