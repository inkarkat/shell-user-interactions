#!/usr/bin/env bats

load fixture

@test "full sweep cycle with custom 4-part application-specific sweeper" {
    export INVOCATIONMESSAGE_SWEEPS='___,A__,_A_,__A,_A_'
    run -0 invocationMessage --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 9 >&2'
    assert_output 'message: A___A___A_A_A___A___A_A_A__   '
}

@test "full sweep cycle with custom 2-part generic sweeper" {
    export SWEEPS='█|  ,█|- ,█|--,█| -,█|--'
    run -0 invocationMessage --message 'message: ' --timespan 0 --sweep-stderr --command 'seq 1 9 >&2'
    assert_output 'message: █|- █|--█| -█|--█|- █|--█| -█|--█|-     '
}
