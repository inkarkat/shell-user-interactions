#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

export S='sleep 0.01;'

export PROGRESSNOTIFICATION_SINK=/dev/stdout

export SAVE_CURSOR_POSITION='[s'
export RESTORE_CURSOR_POSITION='[u'
export ERASE_LINE_TO_END='[0K'

assert_control_output()
{
    if [ "${1?}" = - ]; then
	trcontrols | output="$(printf '%s\n' "$output" | trcontrols)" assert_output -
    else
	output="$(printf '%s\n' "$output" | trcontrols)" assert_output "$(printf '%s\n' "$1" | trcontrols)"
    fi
}
