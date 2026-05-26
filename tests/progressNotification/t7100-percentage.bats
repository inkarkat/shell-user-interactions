#!/usr/bin/env bats

load overlay
load ../delayer

@test "append percentage of reports to 100%" {
    run -0 progressNotification --to overlay --timespan 0 --append-percentage 3 <<<$'first\nsecond\nthird'
    assert_control_output "${R}first (33%)${N}${R}second (66%)${N}${R}third (100%)${N}${C}"
}

@test "prepend percentage of reports to 100%" {
    run -0 progressNotification --to overlay --timespan 0 --prepend-percentage 3 <<<$'first\nsecond\nthird'
    assert_control_output "${R}33%: first${N}${R}66%: second${N}${R}100%: third${N}${C}"
}

@test "append percentage of reports to 3%" {
    run -0 progressNotification --to overlay --timespan 0 --append-percentage 100 <<<$'first\nsecond\nthird'
    assert_control_output "${R}first (1%)${N}${R}second (2%)${N}${R}third (3%)${N}${C}"
}

@test "append percentage of reports exceeding 100%" {
    run -0 progressNotification --to overlay --timespan 0 --append-percentage 2 <<<$'first\nsecond\nthird'
    assert_control_output "${R}first (50%)${N}${R}second (100%)${N}${R}third (150%)${N}${C}"
}

@test "appended percentage when there is an initial delay includes suppressed reports" {
    run -0 progressNotification --to overlay --initial-delay 1001ms --append-percentage 10 <<<$'first\nsecond\nthird'
    assert_control_output "${R}third (30%)${N}${C}"
}

@test "appended percentage when every other report is suppressed includes suppressed reports" {
    run -0 progressNotification --to overlay --timespan 1000ms --append-percentage 10 <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first (10%)${N}${R}third (30%)${N}${R}fifth (50%)${N}${R}seventh (70%)${N}${C}"
}
