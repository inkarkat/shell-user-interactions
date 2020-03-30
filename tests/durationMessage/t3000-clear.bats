#!/usr/bin/env bats

load fixture

@test "clearing an unknown ID causes an error and returns 4" {
    run durationMessage --id doesNotExist --clear
    [ $status -eq 4 ]
    echo >&3 \#"$output"
}
