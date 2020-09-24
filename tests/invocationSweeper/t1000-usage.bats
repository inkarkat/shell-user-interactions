#!/usr/bin/env bats

@test "usage mentions the sweeper" {
    run invocationSweeper --help

    [ $status -eq 0 ]
    [[ "$output" =~ ^"Execute COMMAND while rotating a Knight Rider-alike sweeping control regularly" ]]
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONSWEEPER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONSWEEPER_FAIL_DISPLAY_DELAY=22 run invocationSweeper --help

    [ $status -eq 0 ]
    [[ "$output" =~ $'\t'"0.999 seconds."$'\n' ]]
    [[ "$output" =~ $'\t'"22 seconds."$'\n' ]]
}
