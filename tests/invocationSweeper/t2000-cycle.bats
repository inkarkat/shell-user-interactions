#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../invocationMessage/timer

@test "duration and error output power a sweeper" {
    run invocationSweeper --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: [*   ][-*  ][ -* ][  -*][   *][  *-][ *- ][*-  ][*   ]      first
second
third
fourth
fifth" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "duration and error output power a sweeper and then prints the sigil" {
    run invocationSweeper --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: [*   ][-*  ][ -* ][  -*][   *][  *-][ *- ][*-  ][*   ]${E}OK ("[67]s")first
second
third
fourth
fifth"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
