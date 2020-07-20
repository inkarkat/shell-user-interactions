#!/usr/bin/env bats

export INVOCATIONMESSAGE_SINK="${BATS_TMPDIR}/sink"

setup() {
    > "$INVOCATIONMESSAGE_SINK"
}

assert_sink() {
    [ "$(cat "$INVOCATIONMESSAGE_SINK")" = "${1?}" ]
}


dump_sink() {
    local sinkContents="$(prefix '#' "$INVOCATIONMESSAGE_SINK" | trcontrols)"
    printf >&3 '%s\n' "$sinkContents"
}
