#!/usr/bin/env bats

@test "usage mentions the timer" {
    run invocationTimer --help

    [ $status -eq 0 ]
    [[ "$output" =~ ^"Execute COMMAND while tallying its total running time continuously" ]]
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONTIMER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONTIMER_FAIL_DISPLAY_DELAY=22 run invocationTimer --help

    [ $status -eq 0 ]
    [[ "$output" =~ $'\t'"0.999 seconds."$'\n' ]]
    [[ "$output" =~ $'\t'"22 seconds."$'\n' ]]
}
