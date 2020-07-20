#!/usr/bin/env bats

load fixture
load overlay
load inline

@test "single-line output from the command is individually appended to the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: stdout${N}"
}

@test "multi-line output from the command is individually appended to the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: stderr${N}${R}message: stderr again${N}${R}message: stdout${N}${R}message: stdout again${N}"
}

@test "single-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: stdout${N}${R}message: OK${N}"
}

@test "multi-line output from the command is individually appended to the message and sigil as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: stderr${N}${R}message: stderr again${N}${R}message: stdout${N}${R}message: stdout again${N}${R}message: OK${N}"
}

@test "single-line output from the command is individually appended and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --inline --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: stdout${N}${C}"
}

@test "multi-line output from the command is individually appended and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --inline --clear all --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: stderr${N}${R}message: stderr again${N}${R}message: stdout${N}${R}message: stdout again${N}${C}"
}

@test "single-line output from the command is individually appended and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --inline --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: stdout${N}${R}message: OK${N}${C}"
}

@test "multi-line output from the command is individually appended and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --inline --clear all --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: stderr${N}${R}message: stderr again${N}${R}message: stdout${N}${R}message: stdout again${N}${R}message: OK${N}${C}"
}
