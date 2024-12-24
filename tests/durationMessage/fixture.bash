#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

export NOW=1585739200
export XDG_RUNTIME_DIR="$BATS_TMPDIR"
export DURATION_MESSAGE_SINK=/dev/stdout
export LC_ALL=C TZ=Etc/UTC

export CLR='[0J'
