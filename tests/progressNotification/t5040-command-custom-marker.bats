#!/usr/bin/env bats

load fixture
load command

@test "a custom marker can be configured and leaves the original marker unchanged" {
    export PROGRESSNOTIFICATION_REPORT_MARKER=@@
    PROGRESSNOTIFICATION_COMMANDLINE="${PROGRESSNOTIFICATION_COMMANDLINE//\{\}/$PROGRESSNOTIFICATION_REPORT_MARKER \{\}}"
    runWithInput executed progressNotification --to command

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "[executed]
[{}]
[{}]"
}
