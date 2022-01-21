#!/usr/bin/env bats

load fixture
load notify

@test "notifies a single update" {
    runWithInput executed progressNotification --to notify

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "progressNotification -- executed"
}

@test "notifies the first of three updates because of the default timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to notify

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "progressNotification -- first"
}

@test "notifies all three updates with zero timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to notify --timespan 0

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "progressNotification -- first
progressNotification -- second
progressNotification -- third"
}
