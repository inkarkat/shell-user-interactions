#!/usr/bin/env bats

load fixture
export INVOCATIONNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "short usage contains the extension sinks" {
    run invocationNotification --message 'message: '
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No --to target passed.' ]
    [[ "${lines[1]}" =~ 'o|--to overlay|title|command|notify|bar|foo' ]]
}

@test "long usage lists the extension sinks" {
    run invocationNotification --help
    [ $status -eq 0 ]
    [[ "$output" =~ $'\n    --to|-o bar '.*$'\n    --to|-o foo ' ]]
}
