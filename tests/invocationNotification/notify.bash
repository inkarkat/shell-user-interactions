#!/bin/bash

if [ $# -gt 1 ]; then
    # Invoked by the application-under-test
    printf %s\\n "$*" >> "$RUNS"
    exit 0
fi

load fixture

export INVOCATIONNOTIFICATION_NOTIFY_COMMANDLINE="\"${BASH_SOURCE[0]}\" \"invocationNotification\" -- {}"
export RUNS="${BATS_TMPDIR}/runs"

readonly PREFIX='invocationNotification -- '
readonly SP=' '

setup() {
    rm -f "$RUNS"
}

assert_runs() {
    local output="$(< "$RUNS")"
    assert_output "$@"
}
