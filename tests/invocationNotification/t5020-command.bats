#!/usr/bin/env bats

load fixture
load command

@test "echo launches command with the message" {
    run invocationNotification --to command --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "[message: ]"
}

@test "printf with clear launches command and then launches command with empty argument" {
    run invocationNotification --to command --message 'message: ' --clear all printf executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "[message: ]
[]"
}

@test "echo with clear launches command and then launches command with empty argument" {
    run invocationNotification --to command --message 'message: ' --clear all echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
    assert_runs "[message: ]
[]"
}

@test "a failing command with clear launches command, then again with appended fail sigil, then with empty argument" {
    run invocationNotification --to command --message 'message: ' --clear all --success OK --fail FAILED false

    [ $status -eq 1 ]
    [ "$output" = "" ]
    assert_runs "[message: ]
[message: FAILED]
[]"
}

@test "multi-line error from the command is individually passed to command and finally message with sigil as the command runs" {
    run invocationNotification --to command --message 'message: ' --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "[message: ]
[message: from command]
[message: more from command]
[message: OK]"
}

@test "multi-line error from the command passes message and spinner, then sigil, then empty argument to command" {
    run invocationNotification --to command --message 'message: ' --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_runs "[message: ]
[message: /]
[message: -]
[message: OK]
[]"
}
