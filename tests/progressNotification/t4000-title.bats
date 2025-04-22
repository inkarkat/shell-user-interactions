#!/usr/bin/env bats

load title

@test "prints a single update" {
    run -0 progressNotification --to title <<<'executed'
    assert_control_output "${R}executed${N}${C}"
}

@test "prints the first of three updates because of the default timespan" {
    run -0 progressNotification --to title <<<$'first\nsecond\nthird'
    assert_control_output "${R}first${N}${C}"
}

@test "prints all three updates with zero timespan" {
    run -0 progressNotification --to title --timespan 0 <<<$'first\nsecond\nthird'
    assert_control_output "${R}first${N}${R}second${N}${R}third${N}${C}"
}
