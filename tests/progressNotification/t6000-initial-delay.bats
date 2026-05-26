#!/usr/bin/env bats

load overlay
load ../delayer

@test "single report is suppressed by the initial delay" {
    run -0 progressNotification --to overlay --initial-delay 1001ms <<<'executed'
    assert_control_output ''
}

@test "first two report are suppressed by the initial delay, third goes through" {
    run -0 progressNotification --to overlay --initial-delay 1001ms <<<$'first\nsecond\nthird'
    assert_control_output "${R}third${N}${C}"
}

@test "first two report are suppressed by the initial delay, following go through" {
    run -0 progressNotification --to overlay --initial-delay 1001ms --timespan 0 <<<$'first\nsecond\nthird\nfourth\nfifth'
    assert_control_output "${R}third${N}${R}fourth${N}${R}fifth${N}${C}"
}
