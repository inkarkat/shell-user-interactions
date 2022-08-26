#!/usr/bin/env bats

load fixture
load overlay
export PROGRESSNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "bar extension works like overlay" {
    runWithInput executed progressNotification --to bar

    [ $status -eq 0 ]
    [ "$output" = "${R}executed${N}${C}" ]
}

@test "foo extension executes a custom command" {
    runWithInput executed progressNotification --to foo

    [ $status -eq 0 ]
    [ "$output" = "foo
foo" ]
}
