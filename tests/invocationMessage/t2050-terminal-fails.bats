#!/usr/bin/env bats

load fixture

export INVOCATIONMESSAGE_SINK=/cannot/writeTo
[ -w "$INVOCATIONMESSAGE_SINK" ] && skip "cannot build a sink that cannot be written to"

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned" {
    run -1 invocationMessage --message 'message: ' --clear all echo simplecommand
    assert_output 'simplecommand'
}

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned even if the command fails with another exit status" {
    run -1 invocationMessage --message 'message: ' --clear all exit 42
    assert_output ''
}

@test "when not being able to write the message to the terminal with --or-passthrough, commands just run and 0 is returned" {
    run -0 invocationMessage --or-passthrough --message 'message: ' --clear all --command 'echo commandline' echo simplecommand
    assert_output - <<'EOF'
commandline
simplecommand
EOF
}
