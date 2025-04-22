#!/usr/bin/env bats

load overlay
load delayer

@test "append count of reports to 3" {
    run -0 progressNotification --to overlay --timespan 0 --append-count report --count-to 3 <<<$'first\nsecond\nthird'
    assert_control_output "${R}first (report 1/3)${N}${R}second (report 2/3)${N}${R}third (report 3/3)${N}${C}"
}

@test "prepend count of reports to 100" {
    run -0 progressNotification --to overlay --timespan 0 --prepend-count report --count-to 100 <<<$'first\nsecond\nthird'
    assert_control_output "${R}report 1/100: first${N}${R}report 2/100: second${N}${R}report 3/100: third${N}${C}"
}
