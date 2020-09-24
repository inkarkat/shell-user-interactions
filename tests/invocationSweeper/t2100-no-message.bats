#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "sweeper with message every second" {
    run invocationSweeper --message 'message: ' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ][ -* ][  -*][   *]      " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "sweeper with empty message prevents the synthesis and default clearing" {
    run invocationSweeper --message '' sleep 5

    [ $status -eq 0 ]
    [ "$output" = "[*   ][-*  ][ -* ][  -*][   *]      " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "sweeper without message every second synthesizes the message from the simple command and clears at the end" {
    run invocationSweeper sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}sleep [*   ][-*  ][ -* ][  -*][   *]${RE}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "sweeper without message every second synthesizes the message from the commandline, no-clear option overrides the default clearing " {
    run invocationSweeper --no-clear --command "true && sleep 5"

    [ $status -eq 0 ]
    [ "$output" = "true [*   ][-*  ][ -* ][  -*][   *]      " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "sweeper without message every second synthesizes the message, explicit clear parameter overrides the default clearing " {
    run invocationSweeper --clear failure sleep 5

    [ $status -eq 0 ]
    [ "$output" = "${S}sleep [*   ][-*  ][ -* ][  -*][   *]      " ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
