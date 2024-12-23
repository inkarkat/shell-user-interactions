#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "usage mentions the spinner" {
    run -0 invocationSpinner --help
    assert_output -e '^Execute COMMAND while rotating a spinner regularly'
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONSPINNER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONSPINNER_FAIL_DISPLAY_DELAY=22 run -0 invocationSpinner --help
    assert_output -e $'\t'"0.999 seconds."$'\n'
    assert_output -e $'\t'"22 seconds."$'\n'
}
