#!/usr/bin/env bats

load fixture

@test "single-line error from the command is preceded by spacing out because of passed max length" {
    run -0 invocationMessage --message 'message: ' --max-length 40 --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_control_output "                                        message: ${S}from command"
}

@test "multi-line error from the command is preceded by spacing out because of passed max length" {
    run -0 invocationMessage --message 'message: ' --max-length 50 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"
    assert_control_output "                                                  message: ${S}from command${RE}more from command"
}
