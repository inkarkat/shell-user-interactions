#!/usr/bin/env bats

load fixture
load overlay
load inline

@test "single-line output from the command powers a spinner after the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --spinner --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: /${N}"
}

@test "multi-line output from the command powers a spinner after the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stderr
stderr again
stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}"
}

@test "multi-line output in different order from the command powers a spinner after the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stderr
stdout again
stderr again" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}"
}

@test "full spin cycle" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --command 'seq 1 5'

    [ $status -eq 0 ]
    [ "$output" = "1
2
3
4
5" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: /${N}"
}

@test "single-line output from the command powers a spinner after the message and sigil as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --spinner --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: OK${N}"
}

@test "multi-line output from the command powers a spinner after the message and sigil as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stderr
stderr again
stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: OK${N}"
}

@test "single-line output from the command powers a spinner and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --spinner --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${C}"
}

@test "multi-line output from the command powers a spinner and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --clear all --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stderr
stderr again
stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${C}"
}

@test "single-line output from the command powers a spinner and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --spinner --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: OK${N}${C}"
}

@test "multi-line output from the command powers a spinner and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --clear all --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stderr
stderr again
stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: OK${N}${C}"
}
