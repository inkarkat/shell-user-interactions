#!/usr/bin/env bats

load fixture

@test "error when no command is defined" {
    run -2 invocationNotification --to command --message 'message: ' echo executed
    assert_output 'ERROR: Command notification must define INVOCATIONNOTIFICATION_COMMANDLINE.'
}

@test "the error from a pre-command failure is returned" {
    export INVOCATIONNOTIFICATION_COMMANDLINE="true"
    export INVOCATIONNOTIFICATION_PRE_COMMANDLINE="exit 42"
    run -42 invocationNotification --to command --message 'message: ' echo executed
}

@test "the error from a post-command failure is returned" {
    export INVOCATIONNOTIFICATION_COMMANDLINE="true"
    export INVOCATIONNOTIFICATION_POST_COMMANDLINE="exit 43"
    run -43 invocationNotification --to command --message 'message: ' echo executed
}
