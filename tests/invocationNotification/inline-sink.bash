#!/usr/bin/env bats

export INVOCATIONNOTIFICATION_SINK="${BATS_TMPDIR}/sink"

setup() {
    > "$INVOCATIONNOTIFICATION_SINK"
}

assert_sink() {
    [ "$(cat "$INVOCATIONNOTIFICATION_SINK")" = "${1?}" ]
}


dump_sink() {
    local sinkContents="$(prefix '#' "$INVOCATIONNOTIFICATION_SINK" | trcontrols)"
    printf >&3 '%s\n' "$sinkContents"
}
