#!/usr/bin/env bats

assertSingleRendererMessage() {
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Only one of --inline[-stderr], --spinner[-stderr], or --sweep[-stderr] can be passed." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "no arguments prints message and usage instructions" {
    run invocationNotification
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: Must pass -o|--to overlay|title|command|notify and -m|--message MESSAGE and COMMAND(s)." ]
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

@test "unknown to target prints message and usage instructions" {
    run invocationNotification --to whatever --message message true
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No such target: whatever" ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "use of both inline-stderr and spinner-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-stderr --spinner-stderr
    assertSingleRendererMessage
}

@test "use of both inline-stderr and sweep-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-stderr --sweep-stderr
    assertSingleRendererMessage
}

@test "use of both spinner-stderr and sweep-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --spinner-stderr --sweep-stderr
    assertSingleRendererMessage
}

@test "use of both inline and inline-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline --inline-stderr
    assertSingleRendererMessage
}

@test "use of both --inline-spinner-stderr and --inline prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-spinner-stderr --inline
    assertSingleRendererMessage
}

@test "use of both --inline-spinner-stderr and --spinner-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-spinner-stderr --spinner-stderr
    assertSingleRendererMessage
}

@test "use of both --spinner-stderr-inline and --spinner-stderr prints message and usage instructions" {
    run invocationNotification --to overlay --message message --spinner-stderr-inline --spinner-stderr
    assertSingleRendererMessage
}

@test "use of both --inline-spinner-stderr and --sweep prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-spinner-stderr --sweep
    assertSingleRendererMessage
}

@test "use of both --inline-spinner-stderr and --spinner-stderr-inline prints message and usage instructions" {
    run invocationNotification --to overlay --message message --inline-spinner-stderr --spinner-stderr-inline
    assertSingleRendererMessage
}

@test "use of timespan without processing of lines prints message and usage instructions" {
    run invocationNotification --to overlay --message message --timespan 22
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: --timespan can only be used in combination with one of --inline[-stderr], --spinner[-stderr], or --sweep[-stderr]." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}

@test "invalid timespan prints message" {
    run invocationNotification --to overlay --message message --timespan 42x --spinner-stderr
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Illegal timespan: 42x" ]
}

@test "invalid timer interval prints message" {
    run invocationNotification --to overlay --message message --timer 42x
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Illegal interval: 42x" ]
}

@test "millisecond timer interval prints message" {
    run invocationNotification --to overlay --message message --timer 42ms
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Fractional seconds not allowed for interval." ]
}

@test "use of render timer without rendering prints message and usage instructions" {
    run invocationNotification --to overlay --message message --render-timer 1 --inline
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: --render-timer can only be used in combination with --spinner[-stderr] or --sweep[-stderr]." ]
    [ "${lines[1]%% *}" = 'Usage:' ]
}
