#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "usage mentions the spinner and timer" {
    run -0 invocationTimedSpinner --help
    assert_output -e '^Execute COMMAND while rotating a spinner regularly'
    assert_output -e 'while also tallying its total running time.'
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONTIMEDSPINNER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONTIMEDSPINNER_FAIL_DISPLAY_DELAY=22 run -0 invocationTimedSpinner --help
    assert_output -e $'\t'"0.999 seconds."$'\n'
    assert_output -e $'\t'"22 seconds."$'\n'
}
