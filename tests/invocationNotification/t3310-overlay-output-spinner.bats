#!/usr/bin/env bats

load overlay
load inline-sink

@test "single-line output from the command powers a spinner after the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: ${N}"
}

@test "multi-line output from the command powers a spinner after the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stderr
stderr again
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: ${N}"
}

@test "multi-line output in different order from the command powers a spinner after the message as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --command "$MIXED_COMMAND"
    assert_output - <<'EOF'
stdout
stderr
stdout again
stderr again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: ${N}"
}

@test "full spin cycle" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --command 'seq 1 5'
    assert_output - <<'EOF'
1
2
3
4
5
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: /${N}${R}message: ${N}"
}

@test "single-line output from the command powers a spinner after the message and sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: OK${N}"
}

@test "single-line output from the command powers a spinner after the message and ignores a fail sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner --fail FAIL --command "$ECHO_COMMAND"
    assert_output "stdout"
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: ${N}"
}

@test "multi-line output from the command powers a spinner after the message and sigil as the command runs" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stderr
stderr again
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: OK${N}"
}

@test "single-line output from the command powers a spinner and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner --clear all --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: /${N}${C}"
}

@test "single-line output from the command powers a spinner and ignores a fail clear" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner --clear failure --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: ${N}"
}

@test "multi-line output from the command powers a spinner and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --clear all --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stderr
stderr again
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${C}"
}

@test "single-line output from the command powers a spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner --clear all --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: OK${N}${C}"
}

@test "multi-line output from the command powers a spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner --clear all --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stderr
stderr again
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: OK${N}${C}"
}

@test "a failing silent command with --spinner returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --spinner false
}
