#!/usr/bin/env bats

load fixture
load timer

@test "duration and error output power a spinner" {
    run -0 invocationMessage --message 'message: ' --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    assert_output "message: /-\|/-\ "
}

@test "duration and error output power a spinner and then print sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: /-\|/-\${E}OK ("[67]"s)"$ ]] || dump_output
}

@test "first duration and error output power a spinner and then print sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --render-timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"
    [[ "$output" =~ ^"message: /-\|"("/")?"${E}OK (7s)"$ ]] || dump_output
}

@test "a failing silent command with --render-timer returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --message "$NO_OUTPUT" --render-timer 2 --timespan 0 --spinner-stderr false
    assert_output "$NO_OUTPUT"
}
