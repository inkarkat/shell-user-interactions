#!/usr/bin/env bats

load fixture

@test "--command is not supported with --initial --clear --finish" {
    for c in --initial --clear --finish
    do
	run -2 durationMessage "$c" --id ID --command true
	assert_line -n 0 'ERROR: A COMMAND can only be passed to --update.'
	assert_line -n 2 -e '^Usage:'
    done
}

@test "SIMPLECOMMAND is not supported with --initial --clear --finish" {
    for c in --initial --clear --finish
    do
	run -2 durationMessage "$c" --id ID -- true
	assert_line -n 0 'ERROR: A COMMAND can only be passed to --update.'
	assert_line -n 2 -e '^Usage:'
    done
}

@test "--update-message is not supported with --clear --finish" {
    for c in --clear --finish
    do
	run -2 durationMessage "$c" --id ID --update-message whatever
	assert_line -n 0 'ERROR: --update-message can only be used with --initial and --update.'
	assert_line -n 2 -e '^Usage:'
    done
}

@test "--message is not supported with --clear" {
    run -2 durationMessage --clear --id ID --message whatever
    assert_line -n 0 'ERROR: --message and --update-message cannot be used with --clear.'
    assert_line -n 2 -e '^Usage:'
}
