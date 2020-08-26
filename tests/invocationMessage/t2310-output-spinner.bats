#!/usr/bin/env bats

load fixture
load inline

@test "single-line output from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --spinner --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: / "
}

@test "multi-line output from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again
stderr
stderr again" ]
    assert_sink 'message: /-\| '
}

@test "multi-line output in different order from the command powers a spinner after the message as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again
stderr
stderr again" ]
    assert_sink 'message: /-\| '
}

@test "output powering full spin cycle" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner --command 'seq 1 5'

    [ $status -eq 0 ]
    [ "$output" = "1
2
3
4
5" ]
    assert_sink "message: /-\\|/ "
}

@test "single-line output from the command powers a spinner after the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --spinner --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: /OK"
}

@test "multi-line output from the command powers a spinner after the message and sigil as the command runs" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again
stderr
stderr again" ]
    assert_sink 'message: /-\|OK'
}

@test "single-line output from the command powers a spinner and then cleared" {
    run invocationMessage --message 'message: ' --spinner --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: /${RE}"
}

@test "multi-line output from the command powers a spinner and then cleared" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner --clear all --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again
stderr
stderr again" ]
    assert_sink "${S}message: /-\\|${RE}"
}

@test "single-line output from the command powers a spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --spinner --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: /OK${RE}"
}

@test "multi-line output from the command powers a spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --spinner --clear all --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again
stderr
stderr again" ]
    assert_sink "${S}message: /-\\|OK${RE}"
}
