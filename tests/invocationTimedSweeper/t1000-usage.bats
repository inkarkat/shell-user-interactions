#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "usage mentions the sweeper and timer" {
    run -0 invocationTimedSweeper --help
    assert_output -e '^Execute COMMAND while rotating a Knight Rider-alike sweeping control regularly'
    assert_output -e 'while also tallying
its total running time.' ]]
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONTIMEDSWEEPER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONTIMEDSWEEPER_FAIL_DISPLAY_DELAY=22 run -0 invocationTimedSweeper --help
    assert_output -e $'\t'"0.999 seconds."$'\n'
    assert_output -e $'\t'"22 seconds."$'\n'
}
