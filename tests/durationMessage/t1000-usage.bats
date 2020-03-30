#!/usr/bin/env bats

export ACTIONS='--initial|--clear|--finish|--update'

@test "no arguments prints message and usage instructions" {
    run durationMessage
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No action passed: $ACTIONS" ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run durationMessage --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run durationMessage -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "no action prints message and usage instructions" {
    run durationMessage --message some-message
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No action passed: $ACTIONS" ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "no ID prints message and usage instructions" {
    run durationMessage --initial
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No ID passed." ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
