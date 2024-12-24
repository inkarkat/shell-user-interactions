#!/usr/bin/env bats

load fixture
export INVOCATIONMESSAGE_SINK=/dev/null

@test "capture stdout output from a mixed command" {
    output="$(invocationMessage --message 'message: ' --success OK --command "$BOTH_COMMAND")"
    assert_output - <<'EOF'
stdout
stdout again
EOF
}

@test "suppress stdout and capture stderr output from a mixed command" {
    output="$(invocationMessage --message 'message: ' --success OK --command "$BOTH_COMMAND" 2>&1 >/dev/null)"
    assert_output - <<'EOF'
stderr
stderr again
EOF
}

@test "capture stdout and stderr output from a mixed command" {
    output="$(invocationMessage --message 'message: ' --success OK --command "$MIXED_COMMAND" 2>&1)"
    assert_output - <<'EOF'
stdout
stdout again
stderr
stderr again
EOF
}
