#!/bin/bash

export MULTI_LINE_COMMAND="{ echo first; sleep 0.5; echo second; sleep 0.8; echo third; sleep 2.8; echo fourth; sleep 1.8; echo fifth; sleep 1; } >&2"
export SLEEP_FIRST_COMMAND="{ sleep 4.1; echo fourth; sleep 1.8; echo fifth; sleep 1; } >&2"
