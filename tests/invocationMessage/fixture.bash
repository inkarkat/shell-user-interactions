#!/bin/bash

export S='sleep 0.01;'

export INVOCATIONMESSAGE_SINK=/dev/stdout
export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=0
export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=0

export SINGLE_LINE_COMMAND='echo from command >&2'
export MULTI_LINE_COMMAND="{ echo from command; $S echo more from command; } >&2"
export ECHO_COMMAND='echo stdout'
export BOTH_COMMAND="echo >&2 stderr; $S echo >&2 stderr again; $S echo stdout; $S echo stdout again"
export MIXED_COMMAND="echo stdout; $S echo >&2 stderr; $S echo stdout again; $S echo >&2 stderr again"

export SAVE_CURSOR_POSITION='[s'
export RESTORE_CURSOR_POSITION='[u'
export ERASE_TO_END='[0J'
export SP=' '

assertNoDelay()
{
    export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=11
    export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=11
    run timeout 9 "$@"
    [ $status -ne 124 ]
}
