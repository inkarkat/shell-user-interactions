#!/usr/bin/env bats

load fixture

export INVOCATIONMESSAGE_SINK="${BATS_TMPDIR}/sink"

setup() {
    : > "$INVOCATIONMESSAGE_SINK"
}

assert_sink() {
    [ "$(cat "$INVOCATIONMESSAGE_SINK")" = "${1?}" ] && return 0
    dump_sink
    return 1
}


dump_sink() {
    prefix '#' "$INVOCATIONMESSAGE_SINK" | trcontrols >&3
}
