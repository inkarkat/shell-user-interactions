#!/usr/bin/env bats

load command

printf -v INVOCATIONNOTIFICATION_PRE_COMMANDLINE 'echo PRE >> %q' "$RUNS"
export INVOCATIONNOTIFICATION_PRE_COMMANDLINE
printf -v INVOCATIONNOTIFICATION_POST_COMMANDLINE 'echo POST >> %q' "$RUNS"
export INVOCATIONNOTIFICATION_POST_COMMANDLINE

@test "pre and post commands are executed around reporting" {
    run -0 invocationNotification --to command --message 'message: ' echo executed
    assert_output 'executed'
    assert_runs - <<'EOF'
PRE
[message: ]
POST
EOF
}
