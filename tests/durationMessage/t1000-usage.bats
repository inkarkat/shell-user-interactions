#!/usr/bin/env bats

load fixture

export ACTIONS='--initial|--clear|--finish|--update'

@test "no arguments prints message and usage instructions" {
    run -2 durationMessage
    assert_line -n 0 "ERROR: No action passed: $ACTIONS"
    assert_line -n 2 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
  run -2 durationMessage --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 2 -e '^Usage:'
}

@test "-h prints long usage help" {
  run -0 durationMessage -h
    refute_line -n 0 -e '^Usage:'
}

@test "no action prints message and usage instructions" {
    run -2 durationMessage --message some-message
    assert_line -n 0 "ERROR: No action passed: $ACTIONS"
    assert_line -n 2 -e '^Usage:'
}

@test "no ID prints message and usage instructions" {
    run -2 durationMessage --initial
    assert_line -n 0 "ERROR: No ID passed."
    assert_line -n 2 -e '^Usage:'
}
