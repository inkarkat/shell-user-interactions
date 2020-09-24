#!/usr/bin/env bats

@test "usage mentions the spinner" {
    run invocationSpinner --help

    [ $status -eq 0 ]
    [[ "$output" =~ ^"Execute COMMAND while rotating a spinner regularly" ]]
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONSPINNER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONSPINNER_FAIL_DISPLAY_DELAY=22 run invocationSpinner --help

    [ $status -eq 0 ]
    [[ "$output" =~ $'\t'"0.999 seconds."$'\n' ]]
    [[ "$output" =~ $'\t'"22 seconds."$'\n' ]]
}
