#!/usr/bin/env bats

load fixture
load timer

@test "duration and error output power a spinner" {
    run invocationMessage --message 'message: ' --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-\|/-\ " ]
}

@test "duration and error output power a spinner and then print sigil" {
    run invocationMessage --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: /-\|/-\${ERASE_TO_END}OK ("[67]"s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first duration and error output power a spinner and then print sigil" {
    run invocationMessage --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-\|/${ERASE_TO_END}OK (7s)" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}
