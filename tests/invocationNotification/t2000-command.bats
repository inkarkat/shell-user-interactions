#!/usr/bin/env bats

export INVOCATIONNOTIFICATION_SINK=/dev/null

@test "a simple successful command is executed and returns its output" {
    run invocationNotification --to overlay --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
}

@test "a successful commandline is executed and returns its output" {
    run invocationNotification --to overlay --message 'message: ' --command 'echo executed'

    [ $status -eq 0 ]
    [ "$output" = "executed" ]
}

@test "two commandlines are executed and return their outputs" {
    run invocationNotification --to overlay --message 'message: ' --command 'echo first' --command 'echo second'

    [ $status -eq 0 ]
    [ "$output" = "first
second" ]
}

@test "a simple command and a commandline are executed and return their outputs" {
    run invocationNotification --to overlay --message 'message: ' --command 'echo commandline' echo simplecommand

    [ $status -eq 0 ]
    [ "$output" = "commandline
simplecommand" ]
}
