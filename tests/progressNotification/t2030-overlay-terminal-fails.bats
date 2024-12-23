#!/usr/bin/env bats

load overlay

export PROGRESSNOTIFICATION_SINK=/cannot/writeTo
[ -w "$PROGRESSNOTIFICATION_SINK" ] && skip "cannot build a sink that cannot be written to"

@test "when not being able to write the message to the terminal, no clearing will happen and 1 is returned" {
    run -1 progressNotification --to overlay <<<'executed'
    assert_output ''
}
