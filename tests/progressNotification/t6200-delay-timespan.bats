#!/usr/bin/env bats

load overlay
load delayer

@test "initial delay of 501 ms with default timespan of 1 second suppresses every other report starting with the second" {
    run -0 progressNotification --to overlay --initial-delay 501ms --timespan 1000ms <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}second${N}${R}fourth${N}${R}sixth${N}${R}eighth${N}${C}"
}

@test "initial delay of 1001 ms with timespan of 2 seconds suppresses reports" {
    run -0 progressNotification --to overlay --initial-delay 1001ms --timespan 2000ms <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}third${N}${R}seventh${N}${C}"
}
