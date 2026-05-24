#!/usr/bin/env bats

load overlay
load delayer

@test "append count of reports" {
    run -0 progressNotification --to overlay --timespan 0 --append-count report <<<$'first\nsecond\nthird'
    assert_control_output "${R}first (report 1)${N}${R}second (report 2)${N}${R}third (report 3)${N}${C}"
}

@test "prepend count of reports" {
    run -0 progressNotification --to overlay --timespan 0 --prepend-count report <<<$'first\nsecond\nthird'
    assert_control_output "${R}report 1: first${N}${R}report 2: second${N}${R}report 3: third${N}${C}"
}

@test "appended count when there is an initial delay includes suppressed reports" {
    run -0 progressNotification --to overlay --initial-delay 1001ms --append-count report <<<$'first\nsecond\nthird'
    assert_control_output "${R}third (report 3)${N}${C}"
}

@test "appended count when every other report is suppressed includes suppressed reports" {
    run -0 progressNotification --to overlay --timespan 1000ms --append-count report <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first (report 1)${N}${R}third (report 3)${N}${R}fifth (report 5)${N}${R}seventh (report 7)${N}${C}"
}

@test "append count of empty WHAT" {
    run -0 progressNotification --to overlay --timespan 0 --append-count '' <<<'executed'
    assert_control_output "${R}executed (1)${N}${C}"
}
