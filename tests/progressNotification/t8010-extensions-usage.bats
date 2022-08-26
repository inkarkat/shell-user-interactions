#!/usr/bin/env bats

load fixture
export PROGRESSNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "short usage contains the extension sinks" {
    run progressNotification
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No --to target passed.' ]
    [[ "${lines[1]}" =~ 'o|--to overlay|title|command|notify|foo|bar ' ]]
}

@test "long usage lists the extension sinks" {
    run progressNotification --help
    [ $status -eq 0 ]
    [[ "$output" =~ $'\n    --to|-o bar '.*$'\n    --to|-o foo ' ]]
}
