#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../timer

@test "timer with message every second" {
    run -0 invocationTimer --message 'message: ' sleep 5
    [[ "$output" =~ ^"message: "[12]"s"[23]"s${E}"[34]"s${E}"[45]"s${E}"[56]"s${E}"$ ]] || dump_output
}

@test "timer with empty message prevents the synthesis and default clearing" {
    run -0 invocationTimer --message '' sleep 5
    [[ "$output" =~ ^[12]"s"[23]"s${E}"[34]"s${E}"[45]"s${E}"[56]"s${E}"$ ]] || dump_output
}

@test "timer without message every second synthesizes the message from the simple command and clears at the end" {
    run -0 invocationTimer sleep 5
    [ "$output" = "${S}sleep 5 1s2s${E}3s${E}4s${E}5s${E}${RE}" ] || dump_output
}

@test "timer without message every second synthesizes the message from the commandline, no-clear option overrides the default clearing " {
    run -0 invocationTimer --no-clear --command "true && sleep 5"
    [ "$output" = "true 1s2s${E}3s${E}4s${E}5s${E}" ] || dump_output
}

@test "timer without message every second synthesizes the message, explicit clear parameter overrides the default clearing " {
    run -0 invocationTimer --clear failure sleep 5
    [ "$output" = "${S}sleep 5 1s2s${E}3s${E}4s${E}5s${E}" ] || dump_output
}
