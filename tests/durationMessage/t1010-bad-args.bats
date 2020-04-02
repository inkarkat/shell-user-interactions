#!/usr/bin/env bats

@test "--command is not supported with --initial --clear --finish" {
    for c in --initial --clear --finish
    do
	run durationMessage "$c" --id ID --command true
	[ $status -eq 2 ]
	[ "${lines[0]}" = 'ERROR: A COMMAND can only be passed to --update.' ]
	[ "${lines[2]%% *}" = 'Usage:' ]
    done
}

@test "SIMPLECOMMAND is not supported with --initial --clear --finish" {
    for c in --initial --clear --finish
    do
	run durationMessage "$c" --id ID -- true
	[ $status -eq 2 ]
	[ "${lines[0]}" = 'ERROR: A COMMAND can only be passed to --update.' ]
	[ "${lines[2]%% *}" = 'Usage:' ]
    done
}

@test "--update-message is not supported with --clear --finish" {
    for c in --clear --finish
    do
	run durationMessage "$c" --id ID --update-message whatever
	[ $status -eq 2 ]
	[ "${lines[0]}" = 'ERROR: --update-message can only be used with --initial and --update.' ]
	[ "${lines[2]%% *}" = 'Usage:' ]
    done
}

@test "--message is not supported with --clear" {
    run durationMessage --clear --id ID --message whatever
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: --message and --update-message cannot be used with --clear.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
