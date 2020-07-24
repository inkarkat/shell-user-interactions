#!/bin/bash

setup() {
    printf > "${BATS_TMPDIR}/delays.txt" '%s\n' 1595604{200.0,200.5,201.0,201.5,202.0,202.5,203.0,203.5,204.0,204.5,205.0,205.5,206.0,206.5,207.0,207.5,208.0,208.5,209.0,209.5}00000000
}

delayer() {
    sed -i -e '1w /dev/stdout' -e 1d -- "${BATS_TMPDIR}/delays.txt"
}
export -f delayer
export BATS_TMPDIR DATE=delayer
