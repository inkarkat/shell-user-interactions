#!/usr/bin/env bats

load fixture
load overlay
load delayer

@test "appended count and percentage when every other report is suppressed includes suppressed reports" {
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1000ms --percentage 10 --count element
    [ $status -eq 0 ]
    [ "$output" = "${R}first (element 1 / 10%)${N}${R}third (element 3 / 30%)${N}${R}fifth (element 5 / 50%)${N}${R}seventh (element 7 / 70%)${N}${C}" ]
}

@test "appended count and percentage with modified suffix and prefix" {
    export PROGRESSNOTIFICATION_COUNT_SUFFIX=
    export PROGRESSNOTIFICATION_PERCENTAGE_PREFIX=', that is '
    runWithInput $'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth' progressNotification --to overlay --timespan 1000ms --percentage 10 --count element
    [ $status -eq 0 ]
    [ "$output" = "${R}first (element 1, that is 10%)${N}${R}third (element 3, that is 30%)${N}${R}fifth (element 5, that is 50%)${N}${R}seventh (element 7, that is 70%)${N}${C}" ]
}
