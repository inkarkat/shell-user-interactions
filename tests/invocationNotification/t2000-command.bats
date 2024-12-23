#!/usr/bin/env bats

load fixture

export INVOCATIONNOTIFICATION_SINK=/dev/null

@test "a simple successful command is executed and returns its output" {
    run -0 invocationNotification --to overlay --message 'message: ' echo executed
    assert_output 'executed'
}

@test "a successful commandline is executed and returns its output" {
    run -0 invocationNotification --to overlay --message 'message: ' --command 'echo executed'
    assert_output 'executed'
}

@test "two commandlines are executed and return their outputs" {
    run -0 invocationNotification --to overlay --message 'message: ' --command 'echo first' --command 'echo second'
    assert_output - <<'EOF'
first
second
EOF
}

@test "a simple command and a commandline are executed and return their outputs" {
    run -0 invocationNotification --to overlay --message 'message: ' --command 'echo commandline' echo simplecommand
    assert_output - <<'EOF'
commandline
simplecommand
EOF
}
