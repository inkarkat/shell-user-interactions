#!/bin/bash

export INVOCATIONNOTIFICATION_SINK=/dev/stdout

readonly R="${SAVE_CURSOR_POSITION}[1;1H[37;44m["
readonly N="][0m${ERASE_LINE_TO_END}${RESTORE_CURSOR_POSITION}"
readonly C="${SAVE_CURSOR_POSITION}[1;1H${ERASE_LINE_TO_END}${RESTORE_CURSOR_POSITION}"
