#!/usr/bin/env bats

load overlay
export PROGRESSNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "bar extension works like overlay" {
    run -0 progressNotification --to bar <<<'executed'
    assert_output "${R}executed${N}${C}"
}

@test "foo extension executes a custom command" {
    run -0 progressNotification --to foo <<<'executed'
    assert_output - <<'EOF'
foo
foo
EOF
}
