#!/bin/bash

if [ $# -gt 1 ]; then
    # Invoked by the application-under-test
    printf %s\\n "$*" >> "$RUNS"
    exit 0
fi
export INVOCATIONNOTIFICATION_NOTIFY_COMMANDLINE="\"${BASH_SOURCE[0]}\" \"invocationNotification\" -- {}"
export RUNS="${BATS_TMPDIR}/runs"

readonly PREFIX='invocationNotification -- '
readonly SP=' '

setup() {
    rm -f "$RUNS"
}

assert_runs() {
    local runsContents="$(< "$RUNS")"
    [ "$runsContents" = "${1?}" ]
}

dump_runs() {
    prefix '#' "$RUNS" >&3
}
