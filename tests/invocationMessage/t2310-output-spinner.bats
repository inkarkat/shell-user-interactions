#!/usr/bin/env bats

load inline-sink

@test "single-line output from the command powers a spinner after the message as the command runs" {
    run -0 invocationMessage --message 'message: ' --spinner --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink 'message: / '
}

@test "multi-line output from the command powers a spinner after the message as the command runs" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
stderr
stderr again
EOF
    assert_sink 'message: /-\| '
}

@test "multi-line output in different order from the command powers a spinner after the message as the command runs" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner --command "$MIXED_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
stderr
stderr again
EOF
    assert_sink 'message: /-\| '
}

@test "output powering full spin cycle" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner --command 'seq 1 5'
    assert_output - <<'EOF'
1
2
3
4
5
EOF
    assert_sink 'message: /-\|/ '
}

@test "single-line output from the command powers a spinner after the message and sigil as the command runs" {
    run -0 invocationMessage --message 'message: ' --spinner --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink 'message: /OK'
}

@test "multi-line output from the command powers a spinner after the message and sigil as the command runs" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
stderr
stderr again
EOF
    assert_sink 'message: /-\|OK'
}

@test "single-line output from the command powers a spinner and then cleared" {
    run -0 invocationMessage --message 'message: ' --spinner --clear all --command "$ECHO_COMMAND"
    assert_output "stdout"
    assert_sink "${S}message: /${RE}"
}

@test "multi-line output from the command powers a spinner and then cleared" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner --clear all --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
stderr
stderr again
EOF
    assert_sink "${S}message: /-\\|${RE}"
}

@test "single-line output from the command powers a spinner and then cleared with sigil" {
    run -0 invocationMessage --message 'message: ' --spinner --clear all --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${S}message: /OK${RE}"
}

@test "multi-line output from the command powers a spinner and then cleared with sigil" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --spinner --clear all --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
stderr
stderr again
EOF
    assert_sink "${S}message: /-\\|OK${RE}"
}

@test "a failing silent command with --spinner returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --message "$NO_OUTPUT" --timespan 0 --spinner false
    assert_output ''
}
