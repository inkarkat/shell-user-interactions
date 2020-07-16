#!/usr/bin/env bats

@test "no arguments prints message and usage instructions" {
    run invocationNotification
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Must pass -t|--to overlay|title|command|notify and -m|--message MESSAGE and COMMAND(s)." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
  run invocationNotification --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
  run invocationNotification -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "missing message prints message and usage instructions" {
    run invocationNotification --to overlay true
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Must pass -m|--message MESSAGE." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "missing to target prints message and usage instructions" {
    run invocationNotification --message message true
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No --to target passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "unknwon to target prints message and usage instructions" {
    run invocationNotification --to whatever --message message true
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No such target: whatever" ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "use of both inline-stderr and spinner-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-stderr --spinner-stderr
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Only one of --inline-stderr, --spinner-stderr, or --sweep-stderr can be passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "use of both inline-stderr and sweep-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-stderr --sweep-stderr
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Only one of --inline-stderr, --spinner-stderr, or --sweep-stderr can be passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "use of both spinner-stderr and sweep-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --spinner-stderr --sweep-stderr
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Only one of --inline-stderr, --spinner-stderr, or --sweep-stderr can be passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}
