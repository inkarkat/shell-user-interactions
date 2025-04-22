#!/usr/bin/env bats

load overlay
load ../timer

@test "duration and error output power a spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [ "$output" = "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}" ] || dump_output
}

@test "duration and error output power a spinner and then print sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: OK ("[67]"s)${N}"$ ]] || dump_output

}

@test "first duration and error output power a spinner and then print sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"
    [[ "$output" =~ ^"${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}"("${R}message: /${N}")?"${R}message: OK ("[67]"s)${N}"$ ]] || dump_output
}

@test "a failing silent command with --render-timer --spinner-stderr returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --render-timer 2 --timespan 0 --spinner-stderr false
}
