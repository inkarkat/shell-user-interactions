#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "single report is suppressed by the initial delay" {
    runWithInput executed progressNotification --to overlay --initial-delay 1001ms
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "first two report are suppressed by the initial delay, third goes through" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --initial-delay 1001ms
    [ $status -eq 0 ]
    [ "$output" = "${R}third${N}${C}" ]
}

@test "first two report are suppressed by the initial delay, following go through" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth' progressNotification --to overlay --initial-delay 1001ms --timespan 0
    [ $status -eq 0 ]
    [ "$output" = "${R}third${N}${R}fourth${N}${R}fifth${N}${C}" ]
}
