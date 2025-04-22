#!/usr/bin/env bats

load fixture

@test "with --or-passthrough, echo prints the message when the sink is writable" {
    run -0 invocationMessage --or-passthrough --message 'message: ' --clear all --command 'echo commandline' echo simplecommand
    assert_control_output - <<EOF
${S}message: commandline
simplecommand
${RE}
EOF
}

@test "a failing silent command with passthrough returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --or-passthrough --message "$NO_OUTPUT" false
    assert_control_output "$NO_OUTPUT"
}
