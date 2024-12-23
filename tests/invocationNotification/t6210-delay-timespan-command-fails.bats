#!/usr/bin/env bats

load command
load delayer

export INVOCATIONNOTIFICATION_COMMANDLINE="$COMMANDLINE_FAIL_LATER"
setup() {
    commandSetup
    delayerSetup
    fiveOutputHalfUseCommand=(--to command --message 'message: ' --timespan 1000ms --success OK --clear all --inline-stderr --command 'seq 1 5 >&2')
}

@test "once the command fails with timeout triggering only every second time, it is not invoked any longer and its last status is returned" {
    export COMMANDLINE_FAIL_AFTER=3
    run invocationNotification --to command --message 'message: ' --timespan 1000ms --inline-stderr --command 'seq 1 10 >&2'

    assert_runs <<'EOF'
X
X
X
EOF
    assert_failure $COMMANDLINE_FAIL_AFTER
    assert_output ''
}

@test "with 5 outputs where half are considered, sigil, and clearing, there are a total of 6 invocations" {
    export COMMANDLINE_FAIL_AFTER=7
    run invocationNotification "${fiveOutputHalfUseCommand[@]}"

    assert_runs <<'EOF'
X
X
X
X
X
X
EOF
    assert_success
    assert_output ''
}

@test "when the command fails with timeout triggering on the sigil, it is not invoked any longer and its last status is returned" {
    export COMMANDLINE_FAIL_AFTER=5
    run invocationNotification "${fiveOutputHalfUseCommand[@]}"

    assert_runs <<'EOF'
X
X
X
X
X
EOF
    assert_failure $COMMANDLINE_FAIL_AFTER
    assert_output ''
}

@test "when the command fails with timeout triggering on the clearing, its last status is returned" {
    export COMMANDLINE_FAIL_AFTER=6
    run invocationNotification "${fiveOutputHalfUseCommand[@]}"

    assert_runs <<'EOF'
X
X
X
X
X
X
EOF
    assert_failure $COMMANDLINE_FAIL_AFTER
    assert_output ''
}
