#!/usr/bin/env bats

load ../invocationMessage/fixture
load ../timer

@test "duration and error output power a timed sweeper" {
    run -0 invocationTimedSweeper --message 'message: ' --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: [*   ]"(1s "[-*  ]"[12]s "${E}"|"[-*  ]"[12]s )"[ -* ]"[23]"s ${E}[  -*]"[34]"s ${E}[   *]"[45]"s ${E}[  *-]"[56]"s ${E}[ *- ]"[67]"s ${E}[*-  ]"[67]"s ${E}[*   ]      first
second
third
fourth
fifth"$ ]] || dump_output
}

@test "duration and error output power a timed sweeper and then prints the sigil" {
    run -0 invocationTimedSweeper --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: [*   ]"(1s "[-*  ]"[12]s "${E}"|"[-*  ]"[12]s )"[ -* ]"[23]"s ${E}[  -*]"[34]"s ${E}[   *]"[45]"s ${E}[  *-]"[56]"s ${E}[ *- ]"[67]"s ${E}[*-  ]"[67]"s ${E}[*   ]${E}OK ("[67]s")first
second
third
fourth
fifth"$ ]] || dump_output
}
