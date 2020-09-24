#!/usr/bin/env bats

@test "usage mentions the spinner and timer" {
    run invocationTimedSpinner --help

    [ $status -eq 0 ]
    [[ "$output" =~ ^"Execute COMMAND while rotating a spinner regularly" ]]
    [[ "$output" =~ "while also tallying its total running time." ]]
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONTIMEDSPINNER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONTIMEDSPINNER_FAIL_DISPLAY_DELAY=22 run invocationTimedSpinner --help

    [ $status -eq 0 ]
    [[ "$output" =~ $'\t'"0.999 seconds."$'\n' ]]
    [[ "$output" =~ $'\t'"22 seconds."$'\n' ]]
}
