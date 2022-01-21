#!/usr/bin/env bats

load fixture

@test "error when no command is defined" {
    runWithInput executed progressNotification --to command
    [ $status -eq 2 ]
    [ "$output" = "ERROR: Command notification must define PROGRESSNOTIFICATION_COMMANDLINE." ]
}

@test "the error from a pre-command failure is returned" {
    export PROGRESSNOTIFICATION_COMMANDLINE="true"
    export PROGRESSNOTIFICATION_PRE_COMMANDLINE="exit 42"
    runWithInput executed progressNotification --to command
    [ $status -eq 42 ]
}

@test "the error from a post-command failure is returned" {
    export PROGRESSNOTIFICATION_COMMANDLINE="true"
    export PROGRESSNOTIFICATION_POST_COMMANDLINE="exit 43"
    runWithInput executed progressNotification --to command
    [ $status -eq 43 ]
}
