#!/bin/bash

readonly RUNS="${BATS_TMPDIR}/runs"
setup() {
    rm -f "$RUNS"
}
printf -v INVOCATIONNOTIFICATION_COMMANDLINE 'printf %%s\\\\n {} >> %q' "$RUNS"
export INVOCATIONNOTIFICATION_COMMANDLINE

assert_runs() {
    local runsContents="$(< "$RUNS")"
    [ "$runsContents" = "${1?}" ]
}

dump_runs() {
    local runsContents="$(prefix '#' "$RUNS")"
    printf >&3 '%s\n' "$runsContents"
}
