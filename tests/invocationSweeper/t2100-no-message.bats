#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../timer

@test "sweeper with message every second" {
    run -0 invocationSweeper --message 'message: ' sleep 5
    [ "$output" = "message: [*   ][-*  ][ -* ][  -*][   *]      " ] || dump_output
}

@test "sweeper with empty message prevents the synthesis and default clearing" {
    run -0 invocationSweeper --message '' sleep 5
    [ "$output" = "[*   ][-*  ][ -* ][  -*][   *]      " ] || dump_output
}

@test "sweeper without message every second synthesizes the message from the simple command and clears at the end" {
    run -0 invocationSweeper sleep 5
    [ "$output" = "${S}sleep 5 [*   ][-*  ][ -* ][  -*][   *]${RE}" ] || dump_output
}

@test "sweeper without message every second synthesizes the message from the commandline, no-clear option overrides the default clearing " {
    run -0 invocationSweeper --no-clear --command "true && sleep 5"
    [ "$output" = "true [*   ][-*  ][ -* ][  -*][   *]      " ] || dump_output
}

@test "sweeper without message every second synthesizes the message, explicit clear parameter overrides the default clearing " {
    run -0 invocationSweeper --clear failure sleep 5
    [ "$output" = "${S}sleep 5 [*   ][-*  ][ -* ][  -*][   *]      " ] || dump_output
}
