#!/usr/bin/env bats

load fixture
load inline
load delayer

@test "multi-line error from the command prints every second one including the last because of timespan" {
    run invocationMessage --message 'message: ' --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}1${RE}3${RE}5" ]
}

@test "multi-line error from the command prints every third one not including the last because of timespan" {
    run invocationMessage --message 'message: ' --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}1${RE}4${RE}7" ]
}

@test "multi-line error from the command prints every second one including the last and sigil" {
    run invocationMessage --message 'message: ' --success OK --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}1${RE}3${RE}5${RE}OK" ]
}

@test "multi-line error from the command prints every third one not including the last and sigil" {
    run invocationMessage --message 'message: ' --success OK --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "message: ${S}1${RE}4${RE}7${RE}OK" ]
}

@test "multi-line error from the command prints every second one including the last and then clears" {
    run invocationMessage --message 'message: ' --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 1${RE}message: 3${RE}message: 5${RE}" ]
}

@test "multi-line error from the command prints every third one not including the last and then clears" {
    run invocationMessage --message 'message: ' --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 1${RE}message: 4${RE}message: 7${RE}" ]
}

@test "multi-line error from the command prints every second one including the last and sigil and then clears" {
    run invocationMessage --message 'message: ' --success OK --clear all --timespan 1000ms --inline-stderr --command 'seq 1 5 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 1${RE}message: 3${RE}message: 5${RE}message: OK${RE}" ]
}

@test "multi-line error from the command prints every third one not including the last and sigil and then clears" {
    run invocationMessage --message 'message: ' --success OK --clear all --timespan 1500ms --inline-stderr --command 'seq 1 9 >&2'
    [ $status -eq 0 ]
    [ "$output" = "${S}message: 1${RE}message: 4${RE}message: 7${RE}message: OK${RE}" ]
}
