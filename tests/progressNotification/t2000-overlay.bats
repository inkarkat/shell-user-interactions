#!/usr/bin/env bats

load overlay

@test "prints a single update" {
    run -0 progressNotification --to overlay <<<'executed'
    assert_output "${R}executed${N}${C}"
}

@test "prints the first of three updates because of the default timespan" {
    run -0 progressNotification --to overlay <<<$'first\nsecond\nthird'
    assert_output "${R}first${N}${C}"
}

@test "prints all three updates with zero timespan" {
    run -0 progressNotification --to overlay --timespan 0 <<<$'first\nsecond\nthird'
    assert_output "${R}first${N}${R}second${N}${R}third${N}${C}"
}
