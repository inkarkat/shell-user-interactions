#!/bin/bash

export MULTI_LINE_COMMAND='{ echo first; sleep 0.5; echo second; sleep 0.8; echo third; sleep 2.8; echo fourth; sleep 1.8; echo fifth; sleep 1; } >&2'
export SLEEP_FIRST_COMMAND='{ sleep 4.1; echo fourth; sleep 1.8; echo fifth; sleep 1; } >&2'
export SLEEP_OUT_ERR_OUT='{ sleep 3; echo one; sleep 1; echo two; sleep 1; echo three; sleep 1; echo four; sleep 1; echo >&2 X1; sleep 1; echo >&2 X2 ; sleep 1; echo >&2 X3; sleep 1; echo >&2 X4; sleep 1; echo five; sleep 1; echo six; sleep 1; echo seven; sleep 1; }'

dump_output()
{
    echo "$output" | trcontrols | failThis prefix \# >&3
}
