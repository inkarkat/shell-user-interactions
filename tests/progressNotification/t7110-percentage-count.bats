#!/usr/bin/env bats

load overlay
load ../delayer

@test "appended count and percentage when every other report is suppressed includes suppressed reports" {
    run -0 progressNotification --to overlay --timespan 1000ms --append-percentage 10 --append-count element <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first (element 1) (10%)${N}${R}third (element 3) (30%)${N}${R}fifth (element 5) (50%)${N}${R}seventh (element 7) (70%)${N}${C}"
}

@test "appended count and percentage with modified suffix and prefix" {
    export PROGRESSNOTIFICATION_APPEND_COUNT_SUFFIX=
    export PROGRESSNOTIFICATION_APPEND_PERCENTAGE_PREFIX=', that is '
    run -0 progressNotification --to overlay --timespan 1000ms --append-percentage 10 --append-count element <<<$'first\nsecond\nthird\nfourth\nfifth\nsixth\nseventh\neighth'
    assert_control_output "${R}first (element 1, that is 10%)${N}${R}third (element 3, that is 30%)${N}${R}fifth (element 5, that is 50%)${N}${R}seventh (element 7, that is 70%)${N}${C}"
}

@test "prepended count with total and prepended percentage" {
    run -0 progressNotification --to overlay --prepend-count element --count-to 3 --prepend-percentage 10 <<<'executed'
    assert_control_output "${R}10%: element 1/3: executed${N}${C}"
}

@test "prepended count with total and appended percentage" {
    run -0 progressNotification --to overlay --prepend-count element --count-to 3 --append-percentage 10 <<<'executed'
    assert_control_output "${R}element 1/3: executed (10%)${N}${C}"
}

@test "prepended percentage and appended count with total" {
    run -0 progressNotification --to overlay --append-count element --count-to 3 --prepend-percentage 10 <<<'executed'
    assert_control_output "${R}10%: executed (element 1/3)${N}${C}"
}

@test "appended percentage and appended count with total" {
    run -0 progressNotification --to overlay --append-count element --count-to 3 --append-percentage 10 <<<'executed'
    assert_control_output "${R}executed (element 1/3) (10%)${N}${C}"
}
