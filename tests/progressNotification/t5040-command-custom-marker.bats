#!/usr/bin/env bats

load command

@test "a custom marker can be configured and leaves the original marker unchanged" {
    export PROGRESSNOTIFICATION_REPORT_MARKER=@@
    PROGRESSNOTIFICATION_COMMANDLINE="${PROGRESSNOTIFICATION_COMMANDLINE//\{\}/$PROGRESSNOTIFICATION_REPORT_MARKER \{\}}"
    run -0 progressNotification --to command <<<'executed'
    assert_output ''
    assert_runs <<'EOF'
[executed]
[{}]
[{}]
EOF
}
