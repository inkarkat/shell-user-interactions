#!/usr/bin/env bats

load fixture
load inline
load inline-sink

@test "single-line output from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --inline --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${S}stdout"
}

@test "multi-line output from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "message: ${S}stderr${RE}stderr again${RE}stdout${RE}stdout again"
}

@test "multi-line output in different order from the command is individually appended to the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "message: ${S}stdout${RE}stderr${RE}stdout again${RE}stderr again"
}

@test "single-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --inline --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${S}stdout${RE}OK"
}

@test "multi-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "message: ${S}stderr${RE}stderr again${RE}stdout${RE}stdout again${RE}OK"
}

@test "single-line output from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --inline --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: stdout${RE}"
}

@test "multi-line output from the command is individually appended and then cleared" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --clear all --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "${S}message: stderr${RE}message: stderr again${RE}message: stdout${RE}message: stdout again${RE}"
}

@test "single-line output from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: stdout${RE}message: OK${RE}"
}

@test "multi-line output from the command is individually appended and then cleared with sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline --clear all --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
     assert_sink "${S}message: stderr${RE}message: stderr again${RE}message: stdout${RE}message: stdout again${RE}message: OK${RE}"
}

@test "a failing silent command with --inline returns its exit status" {
    NO_OUTPUT="message: "
    run invocationMessage --message "$NO_OUTPUT" --timespan 0 --inline false

    [ $status -eq 1 ]
    [ "$output" = "" ]
}
