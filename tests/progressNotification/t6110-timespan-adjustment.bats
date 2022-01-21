#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "timespan of 0 second with increase of 1 second suppresses more and more reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 0s+1s
    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${R}second${N}${R}fourth${N}${R}eighth${N}${C}" ]
}

@test "timespan of 1 second with increase of 1 second suppresses more and more reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1s+1s
    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${R}third${N}${R}seventh${N}${C}" ]
}

@test "timespan of 1 second with increase of 25% second suppresses more and more reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1s+25%
    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${R}third${N}${R}fifth${N}${C}" ]
}
