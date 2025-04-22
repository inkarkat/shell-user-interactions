#!/usr/bin/env bats

load fixture

@test "full spin cycle with custom 3-part application-specific spinner" {
    export INVOCATIONMESSAGE_SPINNER='ABC'
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'
    assert_control_output 'message: ABCAB '
}

@test "full spin cycle with custom 2-part generic spinner" {
    export SPINNER='▌▐'
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command 'seq 1 5 >&2'
    assert_control_output 'message: ▌▐▌▐▌ '
}
