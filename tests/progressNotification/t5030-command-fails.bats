#!/usr/bin/env bats

load command

@test "when not being able to execute the command, its output and exit status is returned" {
    PROGRESSNOTIFICATION_COMMANDLINE='LC_ALL=C grep nothere /etc/does/not/exist'
    run -2 progressNotification --to command <<<'executed'
    assert_output 'grep: /etc/does/not/exist: No such file or directory'
}

@test "once the command fails, it is not invoked any longer and its last status is returned" {
    PROGRESSNOTIFICATION_COMMANDLINE="$COMMANDLINE_FAIL_LATER"; export COMMANDLINE_FAIL_AFTER=3
    run progressNotification --to command --timespan 0 <<<$'first\nsecond\nthird\nfourth\nfifth'

    assert_runs <<'EOF'
X
X
X
EOF
    assert_failure $COMMANDLINE_FAIL_AFTER
    assert_output ''
}
