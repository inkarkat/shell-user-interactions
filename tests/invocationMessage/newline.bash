#!/bin/bash

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
    run runneeWrapper "$@"
    output="${output%\$}"
}
