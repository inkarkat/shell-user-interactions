#!/usr/bin/env bats

load fixture

export INVOCATIONNOTIFICATION_SINK="${BATS_TMPDIR}/sink"

setup() {
    : > "$INVOCATIONNOTIFICATION_SINK"
}

assert_sink() {
    [ "$(cat "$INVOCATIONNOTIFICATION_SINK")" = "${1?}" ] && return 0
    dump_sink
    return 1
}


dump_sink() {
    prefix '#' "$INVOCATIONNOTIFICATION_SINK" | trcontrols >&3
}
