#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "timer with message every second" {
    run invocationTimer --message 'message: ' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 1s2s${E}3s${E}4s${E}5s${E}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "timer with empty message prevents the synthesis and default clearing" {
    run invocationTimer --message '' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "1s2s${E}3s${E}4s${E}5s${E}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "timer without message every second synthesizes the message from the simple command and clears at the end" {
    run invocationTimer sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}sleep 1s2s${E}3s${E}4s${E}5s${E}${RE}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "timer without message every second synthesizes the message from the commandline, no-clear option overrides the default clearing " {
    run invocationTimer --no-clear --command "true && sleep 5"

    [ $status -eq 0 ]
    [ "$output" = "true 1s2s${E}3s${E}4s${E}5s${E}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "timer without message every second synthesizes the message, explicit clear parameter overrides the default clearing " {
    run invocationTimer --clear failure sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}sleep 1s2s${E}3s${E}4s${E}5s${E}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
