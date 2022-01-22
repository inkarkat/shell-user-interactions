#!/usr/bin/env bats

@test "no arguments prints message and usage instructions" {
    run progressNotification
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No --to target passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run progressNotification --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run progressNotification -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "unknown to target prints message and usage instructions" {
    run progressNotification --to whatever
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No such target: whatever" ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid timespan prints message" {
    run progressNotification --to overlay --timespan 42x
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Illegal adjustment: x" ]
}

@test "missing count-to number prints message" {
    run progressNotification --to overlay --append-count stuff --count-to
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Need numeric END_COUNT for --count-to." ]
}

@test "non-numeric count-to prints message" {
    run progressNotification --to overlay --prepend-count stuff --count-to foo42
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Need numeric END_COUNT for --count-to." ]
}

@test "missing percentage prints message" {
    run progressNotification --to overlay --append-percentage
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Need numeric END_COUNT for --append-percentage." ]
}

@test "non-numeric percentage prints message" {
    run progressNotification --to overlay --prepend-percentage foo42
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Need numeric END_COUNT for --prepend-percentage." ]
}
