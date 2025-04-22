#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationSpinner spins on both stdout and stderr and prints both" {
    run -0 invocationSpinner --message 'message: ' --command "$BOTH_COMMAND"
    assert_control_output - <<'EOF'
message: /-stdout
\stdout again
| stderr
stderr again
EOF
}

@test "invocationStderrSpinner spins only on stderr and prints only stdout" {
    run -0 invocationStderrSpinner --message 'message: ' --command "$BOTH_COMMAND"
    assert_control_output - <<'EOF'
message: /-stdout
stdout again
 
EOF
}
