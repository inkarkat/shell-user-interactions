#!/usr/bin/env bats

@test "usage mentions the sweeper and timer" {
    run invocationTimedSweeper --help

    [ $status -eq 0 ]
    [[ "$output" =~ ^"Execute COMMAND while rotating a Knight Rider-alike sweeping control regularly" ]]
    [[ "$output" =~ "while also tallying
its total running time." ]]
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONTIMEDSWEEPER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONTIMEDSWEEPER_FAIL_DISPLAY_DELAY=22 run invocationTimedSweeper --help

    [ $status -eq 0 ]
    [[ "$output" =~ $'\t'"0.999 seconds."$'\n' ]]
    [[ "$output" =~ $'\t'"22 seconds."$'\n' ]]
}
