#!/bin/bash

export S='sleep 0.01;'

export PROGRESSNOTIFICATION_SINK=/dev/stdout

export SAVE_CURSOR_POSITION='[s'
export RESTORE_CURSOR_POSITION='[u'
export ERASE_LINE_TO_END='[0K'

inputWrapper()
{
    local input="$1"; local newline="${1:+\\n}"; shift
    printf "%s${newline}" "$input" | "$@"
}
runWithInput()
{
    run inputWrapper "$@"
}
