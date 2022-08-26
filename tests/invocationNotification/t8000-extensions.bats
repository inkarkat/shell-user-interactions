#!/usr/bin/env bats

load fixture
load overlay
export INVOCATIONNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "bar extension works like overlay" {
    run invocationNotification --to bar --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}executed" ]
}

@test "foo extension executes a custom command" {
    run invocationNotification --to foo --message 'message: ' echo executed

    [ $status -eq 0 ]
    [ "$output" = "foo
executed" ]
}
