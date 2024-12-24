#!/bin/bash

load fixture

export INVOCATIONMESSAGE_STDERR_TO_TERM=t

runneeWrapper()
{
    "$@"
    local status=$?
    printf '$'
    return $status
}
runWithFullOutput()
{
    typeset -a runArgs=()
    while [[ "$1" =~ ^- ]]
    do
	runArgs+=("$1"); shift
    done

    run "${runArgs[@]}" runneeWrapper "$@"
    output="${output%\$}"
}
