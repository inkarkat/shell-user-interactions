#!/usr/bin/env bats

load fixture
export INVOCATIONNOTIFICATION_EXTENSIONS_DIR="${BATS_TEST_DIRNAME}/extensions"

@test "short usage contains the extension sinks" {
    run -2 invocationNotification --message 'message: '
    assert_line -n 0 'ERROR: No --to target passed.'
    assert_line -n 1 -e 'o|--to overlay|title|command|notify|bar|foo'
}

@test "long usage lists the extension sinks" {
    run -0 invocationNotification --help
    assert_output -e $'\n    --to|-o bar '.*$'\n    --to|-o foo '
}
