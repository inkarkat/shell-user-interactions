#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "usage mentions the timer" {
    run -0 invocationTimer --help
    assert_output -e '^Execute COMMAND while tallying its total running time continuously'
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONTIMER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONTIMER_FAIL_DISPLAY_DELAY=22 run -0 invocationTimer --help
    assert_output -e $'\t'"0.999 seconds."$'\n'
    assert_output -e $'\t'"22 seconds."$'\n'
}
