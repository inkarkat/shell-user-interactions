#!/usr/bin/env bats

load command

printf -v PROGRESSNOTIFICATION_PRE_COMMANDLINE 'echo PRE >> %q' "$RUNS"
export PROGRESSNOTIFICATION_PRE_COMMANDLINE
printf -v PROGRESSNOTIFICATION_POST_COMMANDLINE 'echo POST >> %q' "$RUNS"
export PROGRESSNOTIFICATION_POST_COMMANDLINE

@test "pre and post commands are executed around reporting" {
    run -0 progressNotification --to command <<<'executed'
    assert_output ''
    assert_runs <<'EOF'
PRE
[executed]
[]
POST
EOF
}

@test "pre and post commands are executed around reporting without clear command" {
    export PROGRESSNOTIFICATION_CLEAR_COMMANDLINE=''
    run -0 progressNotification --to command <<<'executed'
    assert_output ''
    assert_runs <<'EOF'
PRE
[executed]
POST
EOF
}
