#!/usr/bin/env bats

load fixture

assertSingleRendererMessage() {
    assert_failure 2
    assert_line -n 0 'ERROR: Only one of --inline[-stderr], --spinner[-stderr], or --sweep[-stderr] can be passed.'
    assert_line -n 1 -e '^Usage:'
}

@test "no arguments prints message and usage instructions" {
    run -2 invocationMessage
    assert_line -n 0 'ERROR: Must pass -m|--message MESSAGE and COMMAND(s).'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
  run -2 invocationMessage --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 1 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 invocationMessage -h
    refute_line -n 0 -e '^Usage:'
}

@test "missing message prints message and usage instructions" {
    run -2 invocationMessage true
    assert_line -n 0 'ERROR: Must pass -m|--message MESSAGE.'
    assert_line -n 1 -e '^Usage:'
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

@test "use of both --inline-spinner-stderr and --inline prints message and usage instructions" {
    run invocationMessage --message message --inline-spinner-stderr --inline
    assertSingleRendererMessage
}

@test "use of both --inline-spinner-stderr and --spinner-stderr prints message and usage instructions" {
    run invocationMessage --message message --inline-spinner-stderr --spinner-stderr
    assertSingleRendererMessage
}

@test "use of both --inline-spinner-stderr and --sweep prints message and usage instructions" {
    run invocationMessage --message message --inline-spinner-stderr --sweep
    assertSingleRendererMessage
}

@test "use of timespan without processing of lines prints message and usage instructions" {
    run -2 invocationMessage --message message --timespan 22
    assert_line -n 0 'ERROR: --timespan can only be used in combination with one of --inline[-stderr], --spinner[-stderr], or --sweep[-stderr].'
    assert_line -n 1 -e '^Usage:'
}

@test "invalid timespan prints message" {
    run -2 invocationMessage --message message --timespan 42x --spinner-stderr
    assert_output 'ERROR: Illegal timespan: 42x'
}

@test "invalid timer interval prints message" {
    run -2 invocationMessage --message message --timer 42x
    assert_output 'ERROR: Illegal interval: 42x'
}

@test "millisecond timer interval prints message" {
    run -2 invocationMessage --message message --timer 42ms
    assert_output 'ERROR: Fractional seconds not allowed for interval.'
}

@test "use of render timer without rendering prints message and usage instructions" {
    run -2 invocationMessage --message message --render-timer 1 --inline
    assert_line -n 0 'ERROR: --render-timer can only be used in combination with --spinner[-stderr] or --sweep[-stderr].'
    assert_line -n 1 -e '^Usage:'
}
