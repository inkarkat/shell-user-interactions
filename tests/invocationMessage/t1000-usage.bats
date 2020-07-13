#!/usr/bin/env bats

@test "no arguments prints message and usage instructions" {
    run invocationMessage
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Must pass -m|--message MESSAGE and COMMAND(s)." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run invocationMessage --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run invocationMessage -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "missing message prints message and usage instructions" {
    run invocationMessage true
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Must pass -m|--message MESSAGE." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}
