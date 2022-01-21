#!/usr/bin/env bats

load fixture
load notify

@test "three updates with default notify command-line" {
    runWithInput $'first\nsecond\nthird' progressNotification --to notify --timespan 0
    [ "$output" = "" ]
    assert_runs "progressNotification -- first
progressNotification -- second
progressNotification -- third" ]
}

@test "augment default notify command-line with custom arguments" {
    unset PROGRESSNOTIFICATION_NOTIFY_COMMANDLINE
    export PROGRESSNOTIFICATION_NOTIFY_ARGUMENTS="-i terminal -u low"
    export PROGRESSNOTIFICATION_NOTIFY_SEND="${BATS_TEST_DIRNAME}/notify.bash"    # Invoke the fixture as the test dummy.
    runWithInput executed progressNotification --to notify

    [ "$output" = "" ]
    assert_runs "$PROGRESSNOTIFICATION_NOTIFY_ARGUMENTS -- executed"
}
