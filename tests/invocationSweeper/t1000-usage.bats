#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "usage mentions the sweeper" {
    run -0 invocationSweeper --help
    assert_output -e '^Execute COMMAND while rotating a Knight Rider-alike sweeping control regularly'
}

@test "usage includes the adapted custom delay values" {
    INVOCATIONSWEEPER_SUCCESS_DISPLAY_DELAY=0.999 INVOCATIONSWEEPER_FAIL_DISPLAY_DELAY=22 run -0 invocationSweeper --help
    assert_output -e $'\t'"0.999 seconds."$'\n'
    assert_output -e $'\t'"22 seconds."$'\n'
}
