#!/usr/bin/env bats

load overlay
load delayer

@test "multi-line error from the command powers a spinner every second one including the last and sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --timespan 1000ms --spinner-stderr --command 'seq 1 5 >&2'
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: OK${N}"
}

@test "multi-line error from the command powers a spinner every third one not including the last and sigil and then clears" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --clear all --timespan 1500ms --spinner-stderr --command 'seq 1 9 >&2'
    assert_output "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: OK${N}${C}"
}
