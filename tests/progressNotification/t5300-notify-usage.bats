#!/usr/bin/env bats

load fixture

@test "error when custom notify-send application cannot be found" {
    export PROGRESSNOTIFICATION_NOTIFY_SEND=/nonExistingNotifySend
    run -2 progressNotification --to notify <<<'executed'
    assert_output "ERROR: notify-send command (${PROGRESSNOTIFICATION_NOTIFY_SEND}) not found."
}

@test "no error when custom notify-send application cannot be found but a command-line is defined" {
    export PROGRESSNOTIFICATION_NOTIFY_SEND=/nonExistingNotifySend
    export PROGRESSNOTIFICATION_NOTIFY_COMMANDLINE='true {}'
    echo executed | progressNotification --to notify
}
