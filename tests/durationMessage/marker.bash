#!/bin/bash

setup()
{
    export MARKER="${BATS_TMPDIR}/marker"
    > "$MARKER"
    durationMessage --id ID --initial --message 'testing it'
    assert_marker_calls -eq 0
}
assert_marker_calls()
{
    local markerCalls=$([ -r "${MARKER:?}" ] && { cat -- "$MARKER" | wc -l; } || printf 0)
    [ $markerCalls "$@" ]
}
APPEND_COMMAND_ARGUMENTS=(gawk -i inplace '{ print } ENDFILE { print systime() }')
printf -v APPEND_COMMANDLINE '%q ' "${APPEND_COMMAND_ARGUMENTS[@]}"
