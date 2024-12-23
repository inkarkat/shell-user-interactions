#!/usr/bin/env bats

load inline
load newline

@test "true prints the message with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' true
    assert_output "message:${SP}
"
}

@test "true with clear prints and then erases the message, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --clear all true
    assert_output "${S}message: ${RE}"
}

@test "true appends the passed success sigil with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --success OK --fail FAILED true
    assert_output 'message: OK
'
}

@test "true with clear appends the passed success sigil, waits, and erases, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --clear all --success OK --fail FAILED true
    assert_output "${S}message: OK${RE}"
}

@test "single-line error from the command is appended to the message after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --command "$SINGLE_LINE_COMMAND"
    assert_output 'message: from command
'
}

@test "multi-line error from the command is appended to the message after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"
    assert_output "message:${SP}
from command
more from command
"
}

@test "single-line error from the command is appended to the message and sigil after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output 'message: OK; from command
'
}

@test "multi-line error from the command is appended to the message and sigil after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    assert_output 'message: OK
from command
more from command
'
}

@test "single-line error from the command is printed after the cleared message after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --clear all --command "$SINGLE_LINE_COMMAND"
    assert_output "${S}message: ${RE}from command
"
}

@test "multi-line error from the command is printed after the cleared message after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"
    assert_output "${S}message: ${RE}from command
more from command
"
}

@test "single-line error from the command is printed after the cleared message and sigil after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --clear all --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output "${S}message: OK${RE}from command
"
}

@test "multi-line error from the command is printed after the cleared message and sigil after the command concludes with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output "${S}message: OK${RE}from command
more from command
"
}

@test "single-line error from the command is individually appended to the message as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"
    assert_output "message: ${S}from command
"
}

@test "multi-line error from the command is individually appended to the message as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"
    assert_output "message: ${S}from command${RE}more from command
"
}

@test "single-line error from the command is individually appended to the message and sigil as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output "message: ${S}from command${RE}OK
"
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_output "message: ${S}from command${RE}more from command${RE}OK
"
}

@test "multi-line error from the command is individually appended and then cleared, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --clear all --command "$MULTI_LINE_COMMAND"
    assert_output "${S}message: from command${RE}message: more from command${RE}"
}

@test "multi-line error from the command is individually appended and then cleared with sigil, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --inline-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output "${S}message: from command${RE}message: more from command${RE}message: OK${RE}"
}

@test "single-line error from the command powers a spinner after the message as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --spinner-stderr --command "$SINGLE_LINE_COMMAND"
    assert_output "message: /${SP}
"
}

@test "multi-line error from the command powers a spinner after the message as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    assert_output "message: /-${SP}
"
}

@test "single-line error from the command powers a spinner after the message and sigil as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --spinner-stderr --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output 'message: /OK
'
}

@test "multi-line error from the command powers a spinner after the message and sigil as the command runs with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_output 'message: /-OK
'
}

@test "single-line error from the command powers a spinner and then cleared, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --spinner-stderr --clear all --command "$SINGLE_LINE_COMMAND"
    assert_output "${S}message: /${RE}"
}

@test "multi-line error from the command powers a spinner and then cleared, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --clear all --command "$MULTI_LINE_COMMAND"
    assert_output "${S}message: /-${RE}"
}

@test "single-line error from the command powers a spinner and then cleared with sigil, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --spinner-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output "${S}message: /OK${RE}"
}

@test "multi-line error from the command powers a spinner and then cleared with sigil, no newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output "${S}message: /-OK${RE}"
}

@test "multi-line error that contains the statusline marker does not rotate the spinner with newline" {
    runWithFullOutput -0 invocationMessage --message 'message: ' --timespan 0 --spinner-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'
    assert_output "message: /-${SP}
"
}
