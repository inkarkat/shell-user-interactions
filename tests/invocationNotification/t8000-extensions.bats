#!/usr/bin/env bats

load overlay
export INVOCATIONNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "bar extension works like overlay" {
    run -0 invocationNotification --to bar --message 'message: ' echo executed
    assert_output "${R}message: ${N}executed"
}

@test "foo extension executes a custom command" {
    run -0 invocationNotification --to foo --message 'message: ' echo executed
    assert_output - <<'EOF'
foo
executed
EOF
}
