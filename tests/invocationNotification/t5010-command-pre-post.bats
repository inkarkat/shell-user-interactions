#!/usr/bin/env bats

load command

printf -v INVOCATIONNOTIFICATION_PRE_COMMANDLINE 'echo PRE >> %q' "$RUNS"
export INVOCATIONNOTIFICATION_PRE_COMMANDLINE
printf -v INVOCATIONNOTIFICATION_POST_COMMANDLINE 'echo POST >> %q' "$RUNS"
export INVOCATIONNOTIFICATION_POST_COMMANDLINE

@test "pre and post commands are executed around reporting" {
    run invocationNotification --to command --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "PRE
[message: ]
POST"
}
