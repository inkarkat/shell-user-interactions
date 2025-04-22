#!/usr/bin/env bats

load inline
load ../timer

@test "print duration every two seconds and error output inline" {
    run -0 invocationMessage --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: ${S}first${RE}"(\(1s\)\ )?"second${RE}("[12]"s) third${RE}("[34]"s) third${RE}("[345]"s) fourth${RE}("[56]"s) fifth${RE}("[56]"s) "$ ]] || dump_output
}

@test "print duration every two seconds and error output inline and then sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: ${S}first${RE}"(\(1s\)\ )?"second${RE}("[12]"s) third${RE}("[34]"s) third${RE}("[345]"s) fourth${RE}("[56]"s) fifth${RE}("[56]"s) ${RE}OK ("[567]"s)"$ ]] || dump_output
}

@test "first print duration every two seconds and error output inline and then sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$SLEEP_FIRST_COMMAND"
    [[ "$output" =~ ^"message: ${S}(2s) ${RE}(4s) ${RE}("[45]"s) fourth${RE}("[56]"s) fifth${RE}"("(6s) ${RE}")?"OK ("[67]"s)"$ ]] || dump_output
}

@test "a failing silent command with --timer --inline-stderr returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --message "$NO_OUTPUT" --timer 2 --timespan 0 --inline-stderr false
    assert_output "$NO_OUTPUT"
}
