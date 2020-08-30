#!/usr/bin/env bats

load fixture
load inline
load timer

@test "print duration every two seconds and error output inline" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: ${S}first${RE}"(\(1s\)\ )?"second${RE}("[12]"s) third${RE}("[34]"s) third${RE}("[45]"s) fourth${RE}("[56]"s) fifth${RE}("[56]"s) "$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and error output inline and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: ${S}first${RE}"(\(1s\)\ )?"second${RE}("[12]"s) third${RE}("[34]"s) third${RE}("[45]"s) fourth${RE}("[56]"s) fifth${RE}("[56]"s) ${RE}OK ("[567]"s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and error output inline and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --inline-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: ${S}(2s) ${RE}(4s) ${RE}("[45]"s) fourth${RE}("[56]"s) fifth${RE}(6s) ${RE}OK (7s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
