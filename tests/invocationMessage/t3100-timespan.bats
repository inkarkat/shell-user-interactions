#!/usr/bin/env bats

load inline
load ../delayer

@test "multi-line error from the command prints every second one including the last because of timespan" {
    run -0 invocationMessage --message 'message: ' --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "message: ${S}1${RE}3${RE}5"
}

@test "multi-line error from the command prints every third one not including the last because of timespan" {
    run -0 invocationMessage --message 'message: ' --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "message: ${S}1${RE}4${RE}7"
}

@test "multi-line error from the command prints every second one including the last and sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "message: ${S}1${RE}3${RE}5${RE}OK"
}

@test "multi-line error from the command prints every third one not including the last and sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "message: ${S}1${RE}4${RE}7${RE}OK"
}

@test "multi-line error from the command prints every second one including the last and then clears" {
    run -0 invocationMessage --message 'message: ' --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "${S}message: 1${RE}message: 3${RE}message: 5${RE}"
}

@test "multi-line error from the command prints every third one not including the last and then clears" {
    run -0 invocationMessage --message 'message: ' --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${S}message: 1${RE}message: 4${RE}message: 7${RE}"
}

@test "multi-line error from the command prints every second one including the last and sigil and then clears" {
    run -0 invocationMessage --message 'message: ' --success OK --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    assert_control_output "${S}message: 1${RE}message: 3${RE}message: 5${RE}message: OK${RE}"
}

@test "multi-line error from the command prints every third one not including the last and sigil and then clears" {
    run -0 invocationMessage --message 'message: ' --success OK --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    assert_control_output "${S}message: 1${RE}message: 4${RE}message: 7${RE}message: OK${RE}"
}

@test "a failing silent command with --timespan returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --message "$NO_OUTPUT" --timespan 1500ms --inline-stderr false
    assert_control_output "$NO_OUTPUT"
}
