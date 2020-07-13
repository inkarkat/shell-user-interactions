#!/bin/bash

export INVOCATIONMESSAGE_SINK=/dev/stdout
export SAVE_CURSOR_POSITION='[s'
export RESTORE_CURSOR_POSITION='[u'
export ERASE_TO_END='[0J'

assertNoDelay()
{
    export INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY=11
    export INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY=11
    run timeout 9 "$@"
    [ $status -ne 124 ]
}
