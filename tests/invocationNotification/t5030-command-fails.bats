#!/usr/bin/env bats

load command

@test "when not being able to execute the command, no clearing will happen and its exit status is returned" {
    INVOCATIONNOTIFICATION_COMMANDLINE='LANG=C grep nothere /etc/does/not/exist'
    run invocationNotification --to command --message 'message: ' --clear all echo simplecommand

    [ $status -eq 2 ]
    [ "$output" = "grep: /etc/does/not/exist: No such file or directory
simplecommand" ]
}

@test "once the command fails, it is not invoked any longer" {
    printf -v INVOCATIONNOTIFICATION_COMMANDLINE 'echo X >> %q; [ $(cat %q | wc -l) -lt 3 ]' "$RUNS" "$RUNS"
    run invocationNotification --to command --message 'message: ' --clear all --inline-stderr --command 'seq 1 10 >&2'

    assert_runs "X
X
X"
    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "when not being able to execute the command, no clearing will happen and its exit status is returned even if the user command fails with another exit status" {
    INVOCATIONNOTIFICATION_COMMANDLINE='false' run invocationNotification --to command --message 'message: ' --clear all exit 42

    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "when the command fails, its exit status is returned, not the one from the failing user command" {
    INVOCATIONNOTIFICATION_COMMANDLINE='(exit 66)' run invocationNotification --to command --message 'message: ' --clear all exit 42

    [ $status -eq 66 ]
    [ "$output" = "" ]
}