#!/usr/bin/env bats

@test "error when no command is defined" {
    run invocationNotification --to command --message 'message: ' echo executed
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Command notification must define INVOCATIONNOTIFICATION_COMMANDLINE." ]
}

@test "the error from a pre-command failure is returned" {
    export INVOCATIONNOTIFICATION_COMMANDLINE="true"
    export INVOCATIONNOTIFICATION_PRE_COMMANDLINE="exit 42"
    run invocationNotification --to command --message 'message: ' echo executed
    [ $status -eq 42 ]
}

@test "the error from a post-command failure is returned" {
    export INVOCATIONNOTIFICATION_COMMANDLINE="true"
    export INVOCATIONNOTIFICATION_POST_COMMANDLINE="exit 43"
    run invocationNotification --to command --message 'message: ' echo executed
    [ $status -eq 43 ]
}
