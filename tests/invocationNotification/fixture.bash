#!/bin/bash

export INVOCATIONNOTIFICATION_SINK=/dev/stdout
export INVOCATIONNOTIFICATION_SUCCESS_DISPLAY_DELAY=0
export INVOCATIONNOTIFICATION_FAIL_DISPLAY_DELAY=0

export SINGLE_LINE_COMMAND='echo from command >&2'
export MULTI_LINE_COMMAND='{ echo from command; echo more from command; } >&2'

export SAVE_CURSOR_POSITION='[s'
export RESTORE_CURSOR_POSITION='[u'
export ERASE_LINE_TO_END='[0K'

assertNoDelay()
{
    export INVOCATIONNOTIFICATION_SUCCESS_DISPLAY_DELAY=11
    export INVOCATIONNOTIFICATION_FAIL_DISPLAY_DELAY=11
    run timeout 9 "$@"
    [ $status -ne 124 ]
}
