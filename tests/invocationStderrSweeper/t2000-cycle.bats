#!/usr/bin/env bats

load ../invocationMessage/fixture

@test "invocationSweeper spins on both stdout and stderr and prints both" {
    run -0 invocationSweeper --message 'message: ' --command "$BOTH_COMMAND"
    assert_control_output - <<'EOF'
message: [*   ][-*  ]stdout
[ -* ]stdout again
[  -*]      stderr
stderr again
EOF
}

@test "invocationStderrSweeper spins only on stderr and prints only stdout" {
    run -0 invocationStderrSweeper --message 'message: ' --command "$BOTH_COMMAND"
    assert_control_output - <<'EOF'
message: [*   ][-*  ]stdout
stdout again
      
EOF
}
