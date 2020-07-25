#!/usr/bin/env bats

assertSingleRendererMessage() {
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Only one of --inline[-stderr], --spinner[-stderr], or --sweep[-stderr] can be passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

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

@test "use of both inline-stderr and spinner-stderr prints message and usage instructions" {
    run invocationMessage --message message --inline-stderr --spinner-stderr
    assertSingleRendererMessage
}

@test "use of both inline-stderr and sweep-stderr prints message and usage instructions" {
    run invocationMessage --message message --inline-stderr --sweep-stderr
    assertSingleRendererMessage
}

@test "use of both spinner-stderr and sweep-stderr prints message and usage instructions" {
    run invocationMessage --message message --spinner-stderr --sweep-stderr
    assertSingleRendererMessage
}

@test "use of both inline and inline-stderr prints message and usage instructions" {
    run invocationMessage --message message --inline --inline-stderr
    assertSingleRendererMessage
}

@test "use of timespan without processing of lines prints message and usage instructions" {
    run invocationMessage --message message --timespan 22
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: --timespan can only be used in combination with one of --inline[-stderr], --spinner[-stderr], or --sweep[-stderr]." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}
