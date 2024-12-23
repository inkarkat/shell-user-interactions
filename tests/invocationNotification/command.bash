#!/bin/bash

load fixture

readonly RUNS="${BATS_TMPDIR}/runs"
commandSetup() {
    rm -f "$RUNS"
}
setup() {
    commandSetup
}
printf -v INVOCATIONNOTIFICATION_COMMANDLINE 'printf \\[%%s\\]\\\\n {} >> %q' "$RUNS"
export INVOCATIONNOTIFICATION_COMMANDLINE

printf -v COMMANDLINE_FAIL_LATER '(echo X >> %q; [ $(cat %q | wc -l) -lt ${COMMANDLINE_FAIL_AFTER:?} ] || exit $COMMANDLINE_FAIL_AFTER)' "$RUNS" "$RUNS"
export COMMANDLINE_FAIL_AFTER

assert_runs() {
    local output="$(< "$RUNS")"
    assert_output "$@"
}
