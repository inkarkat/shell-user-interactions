#!/usr/bin/env bats

load overlay
load ../delayer

@test "multi-line error from the command appends every second one including the last because of timespan" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 3${N}${R}message: 5${N}"
}

@test "multi-line error from the command appends every third one not including the last because of timespan" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 4${N}${R}message: 7${N}"
}

@test "multi-line error from the command appends every second one including the last and sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 3${N}${R}message: 5${N}${R}message: OK${N}"
}

@test "multi-line error from the command appends every third one not including the last and sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 4${N}${R}message: 7${N}${R}message: OK${N}"
}

@test "multi-line error from the command appends every second one including the last and then clears" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 3${N}${R}message: 5${N}${C}"
}

@test "multi-line error from the command appends every third one not including the last and then clears" {
    run -0 invocationNotification --to overlay --message 'message: ' --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 4${N}${R}message: 7${N}${C}"
}

@test "multi-line error from the command appends every second one including the last and sigil and then clears" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 3${N}${R}message: 5${N}${R}message: OK${N}${C}"
}

@test "multi-line error from the command appends every third one not including the last and sigil and then clears" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${R}message: ${N}${R}message: 1${N}${R}message: 4${N}${R}message: 7${N}${R}message: OK${N}${C}"
}

@test "a failing silent command with --timespan --inline-stderr returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --timespan 1000ms --inline-stderr false
}
