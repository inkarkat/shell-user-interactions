#!/usr/bin/env bats

load overlay

@test "prints initial message and a single update" {
    run -0 progressNotification --to overlay --initial-report 'It is getting started' <<<'executed'
    assert_output "${R}It is getting started${N}${R}executed${N}${C}"
}

@test "prints initial message and the first of three updates because of the default timespan" {
    run -0 progressNotification --to overlay --initial-report 'It is getting started' <<<$'first\nsecond\nthird'
    assert_output "${R}It is getting started${N}${R}first${N}${C}"
}

@test "prints just the initial message when there's no input at all" {
    run -0 progressNotification --to overlay --initial-report 'It is getting started' < /dev/null
    assert_output "${R}It is getting started${N}${C}"
}
