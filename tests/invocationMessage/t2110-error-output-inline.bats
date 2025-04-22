#!/usr/bin/env bats

load inline

@test "single-line error from the command is individually appended to the message as the command runs" {
    run -0 invocationMessage --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_control_output "message: ${S}from command"
}

@test "multi-line error from the command is individually appended to the message as the command runs" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"
    assert_control_output "message: ${S}from command${RE}more from command"
}

@test "single-line error from the command is individually appended to the message and sigil as the command runs" {
    run -0 invocationMessage --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"
    assert_control_output "message: ${S}from command${RE}OK"
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_control_output "message: ${S}from command${RE}more from command${RE}OK"
}

@test "single-line error from the command is individually appended and then cleared" {
    run -0 invocationMessage --message 'message: ' --inline-stderr --clear all --command "$SINGLE_LINE_COMMAND"
    assert_control_output "${S}message: from command${RE}"
}

@test "multi-line error from the command is individually appended and then cleared" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --clear all --command "$MULTI_LINE_COMMAND"
    assert_control_output "${S}message: from command${RE}message: more from command${RE}"
}

@test "single-line error from the command is individually appended and then cleared with sigil" {
    run -0 invocationMessage --message 'message: ' --inline-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"
    assert_control_output "${S}message: from command${RE}message: OK${RE}"
}

@test "multi-line error from the command is individually appended and then cleared with sigil" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_control_output "${S}message: from command${RE}message: more from command${RE}message: OK${RE}"
}

@test "multi-line error that contains the statusline marker is not individually appended" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'
    assert_control_output "message: ${S}first${RE}last"
}

@test "a failing silent command with --inline-stderr returns its exit status" {
    NO_OUTPUT="message: "
    run -1 invocationMessage --message "$NO_OUTPUT" --timespan 0 --inline-stderr false
    assert_control_output "$NO_OUTPUT"
}
