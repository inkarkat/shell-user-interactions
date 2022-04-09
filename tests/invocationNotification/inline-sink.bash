#!/usr/bin/env bats

export INVOCATIONNOTIFICATION_SINK="${BATS_TMPDIR}/sink"

setup() {
    > "$INVOCATIONNOTIFICATION_SINK"
}

assert_sink() {
    [ "$(cat "$INVOCATIONNOTIFICATION_SINK")" = "${1?}" ]
}


dump_sink() {
    prefix '#' "$INVOCATIONNOTIFICATION_SINK" | trcontrols >&3
}
