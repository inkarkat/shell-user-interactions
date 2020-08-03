#!/usr/bin/env bats

load command

@test "a custom marker can be configured and leaves the original marker unchanged" {
    export INVOCATIONNOTIFICATION_MESSAGE_MARKER=@@
    INVOCATIONNOTIFICATION_COMMANDLINE="${INVOCATIONNOTIFICATION_COMMANDLINE//\{\}/$INVOCATIONNOTIFICATION_MESSAGE_MARKER \{\}}"
    run invocationNotification --to command --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "[message: ]
[{}]"
}
