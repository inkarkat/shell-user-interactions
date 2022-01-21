#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "default timespan of 1 second suppresses every other report" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1000ms
    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${R}third${N}${R}fifth${N}${R}seventh${N}${C}" ]
}

@test "timespan of 1500 ms suppresses reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1500ms
    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${R}fourth${N}${R}seventh${N}${C}" ]
}

@test "timespan of 9999 ms suppresses all reports but the first" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 9999ms
    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${C}" ]
}
