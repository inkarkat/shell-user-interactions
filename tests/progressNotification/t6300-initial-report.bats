#!/usr/bin/env bats

load fixture
load overlay

@test "prints initial message and a single update" {
    runWithInput executed progressNotification --to overlay --initial-report 'It is getting started'

    [ $status -eq 0 ]
    [ "$output" = "${R}It is getting started${N}${R}executed${N}${C}" ]
}

@test "prints initial message and the first of three updates because of the default timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to overlay --initial-report 'It is getting started'

    [ $status -eq 0 ]
    [ "$output" = "${R}It is getting started${N}${R}first${N}${C}" ]
}

@test "prints just the initial message when there's no input at all" {
    runWithInput '' progressNotification --to overlay --initial-report 'It is getting started'

    [ $status -eq 0 ]
    [ "$output" = "${R}It is getting started${N}${C}" ]
}
