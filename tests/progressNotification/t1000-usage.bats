#!/usr/bin/env bats

load fixture

@test "no arguments prints message and usage instructions" {
    run -2 progressNotification
    assert_line -n 0 'ERROR: No --to target passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
  run -2 progressNotification --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 progressNotification -h
    refute_line -n 0 -e '^Usage:'
}

@test "unknown to target prints message and usage instructions" {
    run -2 progressNotification --to whatever
    assert_line -n 0 "ERROR: No such target: whatever"
    assert_line -n 1 -e '^Usage:'
}

@test "invalid timespan prints message" {
    run -2 progressNotification --to overlay --timespan 42x
    assert_output 'ERROR: Illegal adjustment: x'
}

@test "missing count-to number prints message" {
    run -2 progressNotification --to overlay --append-count stuff --count-to
    assert_output 'ERROR: Need numeric END_COUNT for --count-to.'
}

@test "non-numeric count-to prints message" {
    run -2 progressNotification --to overlay --prepend-count stuff --count-to foo42
    assert_output 'ERROR: Need numeric END_COUNT for --count-to.'
}

@test "missing percentage prints message" {
    run -2 progressNotification --to overlay --append-percentage
    assert_output 'ERROR: Need numeric END_COUNT for --append-percentage.'
}

@test "non-numeric percentage prints message" {
    run -2 progressNotification --to overlay --prepend-percentage foo42
    assert_output 'ERROR: Need numeric END_COUNT for --prepend-percentage.'
}
