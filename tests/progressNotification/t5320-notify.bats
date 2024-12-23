#!/usr/bin/env bats

load notify

@test "notifies a single update" {
    run -0 progressNotification --to notify <<<'executed'
    assert_output ''
    assert_runs 'progressNotification -- executed'
}

@test "notifies the first of three updates because of the default timespan" {
    run -0 progressNotification --to notify <<<$'first\nsecond\nthird'
    assert_output ''
    assert_runs 'progressNotification -- first'
}

@test "notifies all three updates with zero timespan" {
    run -0 progressNotification --to notify --timespan 0 <<<$'first\nsecond\nthird'
    assert_output ''
    assert_runs <<'EOF'
progressNotification -- first
progressNotification -- second
progressNotification -- third"
EOF
}
