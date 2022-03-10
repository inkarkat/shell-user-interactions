#!/bin/bash

export MS='sleep 0.01;'

export INVOCATIONMESSAGE_SINK=/dev/stdout
export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=0
export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=0

export SINGLE_LINE_COMMAND='echo from command >&2'
export MULTI_LINE_COMMAND="{ echo from command; $MS echo more from command; } >&2"
export ECHO_COMMAND='echo stdout'
export BOTH_COMMAND="echo >&2 stderr; $MS echo >&2 stderr again; $MS echo stdout; $MS echo stdout again"
export MIXED_COMMAND="echo stdout; $MS echo >&2 stderr; $MS echo stdout again; $MS echo >&2 stderr again"

export S='[s'
export R='[u'
export E='[0J'
export RE="${R}${E}"
export SP=' '

unset INVOCATIONMESSAGE_SPINNER SPINNER
unset INVOCATIONMESSAGE_SWEEPS SWEEPS

assertNoDelay()
{
    export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=11
    export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=11
    run timeout 9 "$@"
    [ $status -ne 124 ]
}
