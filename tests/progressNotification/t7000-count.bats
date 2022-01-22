#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "append count of reports" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --timespan 0 --append-count report
    [ $status -eq 0 ]
    [ "$output" = "${R}first (report 1)${N}${R}second (report 2)${N}${R}third (report 3)${N}${C}" ]
}

@test "prepend count of reports" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --timespan 0 --prepend-count report
    [ $status -eq 0 ]
    [ "$output" = "${R}report 1: first${N}${R}report 2: second${N}${R}report 3: third${N}${C}" ]
}

@test "appended count when there is an initial delay includes suppressed reports" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --initial-delay 1001ms --append-count report
    [ $status -eq 0 ]
    [ "$output" = "${R}third (report 3)${N}${C}" ]
}

@test "appended count when every other report is suppressed includes suppressed reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1000ms --append-count report
    [ $status -eq 0 ]
    [ "$output" = "${R}first (report 1)${N}${R}third (report 3)${N}${R}fifth (report 5)${N}${R}seventh (report 7)${N}${C}" ]
}

@test "append count of empty WHAT" {
    runWithInput executed progressNotification --to overlay --timespan 0 --append-count ''
    [ $status -eq 0 ]
    [ "$output" = "${R}executed (1)${N}${C}" ]
}
