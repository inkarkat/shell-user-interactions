#!/usr/bin/env bats

load fixture
load command

@test "when not being able to execute the command, its output and exit status is returned" {
    PROGRESSNOTIFICATION_COMMANDLINE='LC_ALL=C grep nothere /etc/does/not/exist'
    runWithInput executed progressNotification --to command

    [ $status -eq 2 ]
    [ "$output" = "grep: /etc/does/not/exist: No such file or directory" ]
}

@test "once the command fails, it is not invoked any longer and its last status is returned" {
    PROGRESSNOTIFICATION_COMMANDLINE="$COMMANDLINE_FAIL_LATER"; export COMMANDLINE_FAIL_AFTER=3
    runWithInput $'first\nsecond\nthird\nfourth\nfifth' progressNotification --to command --timespan 0

    assert_runs "X
X
X"
    [ $status -eq $COMMANDLINE_FAIL_AFTER ]
    [ "$output" = "" ]
}
