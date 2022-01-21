#!/usr/bin/env bats

load fixture
load title

export PROGRESSNOTIFICATION_SINK=/cannot/writeTo
[ -w "$PROGRESSNOTIFICATION_SINK" ] && skip "cannot build a sink that cannot be written to"

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned" {
    runWithInput executed progressNotification --to title

    [ $status -eq 1 ]
    [ "$output" = "" ]
}
