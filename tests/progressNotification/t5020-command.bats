#!/usr/bin/env bats

load fixture
load command

@test "executes command on a single update" {
    runWithInput executed progressNotification --to command

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "[executed]
[]"
}

@test "executes command on the first of three updates because of the default timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to command

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "[first]
[]"
}

@test "executes command on all three updates with zero timespan" {
    runWithInput $'first\nsecond\nthird' progressNotification --to command --timespan 0

    [ $status -eq 0 ]
    assert_runs "[first]
[second]
[third]
[]"
}

@test "executes special clear command" {
    printf -v PROGRESSNOTIFICATION_CLEAR_COMMANDLINE 'printf \\{%%s\\}\\\\n {} >> %q' "$RUNS"
    export PROGRESSNOTIFICATION_CLEAR_COMMANDLINE
    runWithInput $'first\nsecond\nthird' progressNotification --to command --timespan 0

    [ $status -eq 0 ]
    assert_runs "[first]
[second]
[third]
{}"
}
@test "executes no clear command" {
    export PROGRESSNOTIFICATION_CLEAR_COMMANDLINE=''
    runWithInput $'first\nsecond\nthird' progressNotification --to command --timespan 0

    [ $status -eq 0 ]
    assert_runs "[first]
[second]
[third]"
}
