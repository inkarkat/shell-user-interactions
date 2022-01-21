#!/usr/bin/env bats

load fixture
load title

@test "prints a single update" {
    runWithInput executed progressNotification --to title

    [ $status -eq 0 ]
    [ "$output" = "${R}executed${N}${C}" ]
}

@test "prints the first of three updates because of the default timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to title

    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${C}" ]
}

@test "prints all three updates with zero timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to title --timespan 0

    [ $status -eq 0 ]
    [ "$output" = "${R}first${N}${R}second${N}${R}third${N}${C}" ]
}
