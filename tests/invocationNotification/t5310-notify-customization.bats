#!/usr/bin/env bats

load notify

@test "single match with default notify command-line" {
    run invocationNotification --to notify --message 'message: ' --success OK --clear all echo executed
    [ "$output" = "executed" ]
    assert_runs "invocationNotification -- message:${SP}
invocationNotification -- message: OK
invocationNotification --" ]
}

@test "augment default notify command-line (that gets the command name inserted) with custom arguments" {
    unset INVOCATIONNOTIFICATION_NOTIFY_COMMANDLINE
    export INVOCATIONNOTIFICATION_NOTIFY_ARGUMENTS="-i terminal -u low"
    export INVOCATIONNOTIFICATION_NOTIFY_SEND="${BATS_TEST_DIRNAME}/notify.bash"    # Invoke the fixture as the test dummy.
    run invocationNotification --to notify --message 'message: ' echo executed

    [ "$output" = "executed" ]
    assert_runs "$INVOCATIONNOTIFICATION_NOTIFY_ARGUMENTS echo -- message: "
}
