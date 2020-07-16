#!/usr/bin/env bats

load fixture
load overlay

@test "single-line error from the command is individually appended to the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}" ]
}

@test "multi-line error from the command is individually appended to the message as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}" ]
}

@test "single-line error from the command is individually appended to the message and sigil as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${R}message: OK${N}" ]
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${R}message: OK${N}" ]
}

@test "single-line error from the command is individually appended and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${C}" ]
}

@test "multi-line error from the command is individually appended and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${C}" ]
}

@test "single-line error from the command is individually appended and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${R}message: OK${N}${C}" ]
}

@test "multi-line error from the command is individually appended and then cleared with sigil" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: from command${N}${R}message: more from command${N}${R}message: OK${N}${C}" ]
}

@test "multi-line error that contains the statusline marker is not individually appended" {
    run invocationNotification --to overlay --message 'message: ' --inline-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'

    [ $status -eq 0 ]
    [ "$output" = "${R}message: ${N}${R}message: first${N}${R}message: last${N}" ]
}
