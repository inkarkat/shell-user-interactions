#!/usr/bin/env bats

load fixture
load command

printf -v PROGRESSNOTIFICATION_PRE_COMMANDLINE 'echo PRE >> %q' "$RUNS"
export PROGRESSNOTIFICATION_PRE_COMMANDLINE
printf -v PROGRESSNOTIFICATION_POST_COMMANDLINE 'echo POST >> %q' "$RUNS"
export PROGRESSNOTIFICATION_POST_COMMANDLINE

@test "pre and post commands are executed around reporting" {
    runWithInput executed progressNotification --to command

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "PRE
[executed]
[]
POST"
}

@test "pre and post commands are executed around reporting without clear command" {
    export PROGRESSNOTIFICATION_CLEAR_COMMANDLINE=''
    runWithInput executed progressNotification --to command

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "PRE
[executed]
POST"
}
