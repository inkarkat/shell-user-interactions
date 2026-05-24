#!/usr/bin/env bats

load overlay
load delayer

@test "default timespan of 1 second suppresses every other report" {
    run -0 progressNotification --to overlay --timespan 1000ms <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first${N}${R}third${N}${R}fifth${N}${R}seventh${N}${C}"
}

@test "timespan of 1500 ms suppresses reports" {
    run -0 progressNotification --to overlay --timespan 1500ms <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first${N}${R}fourth${N}${R}seventh${N}${C}"
}

@test "timespan of 9999 ms suppresses all reports but the first" {
    run -0 progressNotification --to overlay --timespan 9999ms <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first${N}${C}"
}
