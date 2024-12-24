#!/usr/bin/env bats

load notify

@test "three updates with default notify command-line" {
    run progressNotification --to notify --timespan 0 <<<$'first\nsecond\nthird'
    assert_output ''
    assert_runs <<'EOF'
progressNotification -- first
progressNotification -- second
progressNotification -- third
EOF
}

@test "augment default notify command-line with custom arguments" {
    unset PROGRESSNOTIFICATION_NOTIFY_COMMANDLINE
    export PROGRESSNOTIFICATION_NOTIFY_ARGUMENTS="-i terminal -u low"
    export PROGRESSNOTIFICATION_NOTIFY_SEND="${BATS_TEST_DIRNAME}/notify.bash"    # Invoke the fixture as the test dummy.
    run progressNotification --to notify <<<'executed'

    assert_output ''
    assert_runs "$PROGRESSNOTIFICATION_NOTIFY_ARGUMENTS -- executed"
}
