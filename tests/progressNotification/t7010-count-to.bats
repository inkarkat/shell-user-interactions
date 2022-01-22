#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "append count of reports to 3" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --timespan 0 --append-count report --count-to 3
    [ $status -eq 0 ]
    [ "$output" = "${R}first (report 1/3)${N}${R}second (report 2/3)${N}${R}third (report 3/3)${N}${C}" ]
}

@test "prepend count of reports to 100" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --timespan 0 --prepend-count report --count-to 100
    [ $status -eq 0 ]
    [ "$output" = "${R}report 1/100: first${N}${R}report 2/100: second${N}${R}report 3/100: third${N}${C}" ]
}
