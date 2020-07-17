#!/usr/bin/env bats

@test "error when custom notify-send application cannot be found" {
    export INVOCATIONNOTIFICATION_NOTIFY_SEND=/nonExistingNotifySend
    run invocationNotification --to notify --message 'message: ' echo executed
    [ $status -eq 2 ]
    [ "$output" = "ERROR: notify-send command (${INVOCATIONNOTIFICATION_NOTIFY_SEND}) not found." ]
}

@test "no error when custom notify-send application cannot be found but a command-line is defined" {
    export INVOCATIONNOTIFICATION_NOTIFY_SEND=/nonExistingNotifySend
    export INVOCATIONNOTIFICATION_NOTIFY_COMMANDLINE='true {}'
    invocationNotification --to notify --message 'message: ' echo executed
}
