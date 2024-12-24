#!/usr/bin/env bats

load overlay
load inline-sink

@test "single-line output from the command is individually appended / error output rotates the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --spinner-stderr-inline --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: / stdout${N}${R}message: stdout${N}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr-inline --clear all --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\ stdout${N}${R}message: | stdout again${N}${R}message: OK${N}${C}"
}

@test "empty line output from the command also rotates the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --spinner-stderr-inline --command "$WITH_EMPTY_COMMAND"
    assert_output - <<'EOF'
foo
bar

bar
EOF
    assert_sink "${R}message: ${N}${R}message: / foo${N}${R}message: - bar${N}${R}message: \\${N}${R}message: | bar${N}${R}message: bar${N}"
}

@test "a failing silent command with --spinner-stderr-inline returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --spinner-stderr-inline false
}
