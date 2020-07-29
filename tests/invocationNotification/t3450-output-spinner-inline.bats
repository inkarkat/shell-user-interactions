#!/usr/bin/env bats

load fixture
load overlay
load inline

@test "single-line output from the command is individually appended / error output rotates the spinner" {
    run invocationNotification --to overlay --message 'message: ' --spinner-stderr-inline --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: / stdout${N}${R}message: stdout${N}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr-inline --clear all --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\ stdout${N}${R}message: | stdout again${N}${R}message: OK${N}${C}"
}

@test "empty line output from the command also rotates the spinner" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr-inline --command "$WITH_EMPTY_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "foo
bar

bar" ]
    assert_sink "${R}message: ${N}${R}message: / foo${N}${R}message: - bar${N}${R}message: \\${N}${R}message: | bar${N}${R}message: bar${N}"
}
