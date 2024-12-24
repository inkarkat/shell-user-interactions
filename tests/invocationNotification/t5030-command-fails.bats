#!/usr/bin/env bats

load command

@test "when not being able to execute the command, no clearing will happen and its exit status is returned" {
    INVOCATIONNOTIFICATION_COMMANDLINE='LC_ALL=C grep nothere /etc/does/not/exist'
    run -2 invocationNotification --to command --message 'message: ' --clear all echo simplecommand
    assert_output - <<'EOF'
grep: /etc/does/not/exist: No such file or directory
simplecommand
EOF
}

@test "once the command fails, it is not invoked any longer and its last status is returned" {
    INVOCATIONNOTIFICATION_COMMANDLINE="$COMMANDLINE_FAIL_LATER"; export COMMANDLINE_FAIL_AFTER=3
    run invocationNotification --to command --message 'message: ' --clear all --inline-stderr --command 'seq 1 10 >&2'

    assert_runs <<'EOF'
X
X
X
EOF
    assert_failure $COMMANDLINE_FAIL_AFTER
    assert_output ''
}

@test "when not being able to execute the command, no clearing will happen and its exit status is returned even if the user command fails with another exit status" {
    INVOCATIONNOTIFICATION_COMMANDLINE='false' run -1 invocationNotification --to command --message 'message: ' --clear all exit 42
    assert_output ''
}

@test "when the command fails, its exit status is returned, not the one from the failing user command" {
    INVOCATIONNOTIFICATION_COMMANDLINE='(exit 66)' run -66 invocationNotification --to command --message 'message: ' --clear all exit 42
    assert_output ''
}
