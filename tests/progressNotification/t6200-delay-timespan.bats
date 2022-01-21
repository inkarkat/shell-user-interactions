#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "initial delay of 501 ms with default timespan of 1 second suppresses every other report starting with the second" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --initial-delay 501ms --timespan 1000ms
    [ $status -eq 0 ]
    [ "$output" = "${R}second${N}${R}fourth${N}${R}sixth${N}${R}eighth${N}${C}" ]
}

@test "initial delay of 1001 ms with timespan of 2 seconds suppresses reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --initial-delay 1001ms --timespan 2000ms
    [ $status -eq 0 ]
    [ "$output" = "${R}third${N}${R}seventh${N}${C}" ]
}
