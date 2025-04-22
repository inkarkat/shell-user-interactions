#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../timer

@test "duration and error output power a sweeper" {
    run -0 invocationSweeper --message 'message: ' --command "$MULTI_LINE_COMMAND"
    [ "$output" = "message: [*   ][-*  ][ -* ][  -*][   *][  *-][ *- ][*-  ][*   ]      first
second
third
fourth
fifth" ] || dump_output
}

@test "duration and error output power a sweeper and then prints the sigil" {
    run -0 invocationSweeper --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: [*   ][-*  ][ -* ][  -*][   *][  *-][ *- ][*-  ][*   ]${E}OK ("[67]s")first
second
third
fourth
fifth"$ ]] || dump_output
}
