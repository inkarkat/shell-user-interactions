#!/usr/bin/env bats

load fixture

@test "with --or-passthrough, echo prints the message when the sink is writable" {
    run invocationMessage --or-passthrough --message 'message: ' --clear all --command 'echo commandline' echo simplecommand

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: commandline
simplecommand
${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}
