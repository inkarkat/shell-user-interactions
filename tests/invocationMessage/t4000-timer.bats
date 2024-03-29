#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds" {
    run invocationMessage --message 'message: ' --timer 2 sleep 5

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "[23]"s"[45]"s${E}"[56]"s${E}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds, ignoring stderr" {
    run invocationMessage --message 'message: ' --timer 2 --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: 1s"[234]s"${E}"[45]s"${E}"[56]s"${E}"[67]s"${E}first
second
third
fourth
fifth"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds is suppressed with initial delay of 3 seconds due to shortness" {
    run invocationMessage --message 'message: ' --initial-delay 3 --timer 2 sleep 2.5

    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration" {
    run invocationMessage --message 'message: ' --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "[45]s(""[56]s"${E}")?$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and then includes final duration in sigil" {
    run invocationMessage --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 4s5s${E}${E}OK (5s)" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and inclusion of final duration in sigil is suppressed by clearing the prefix and suffix configuration" {
    export INVOCATIONMESSAGE_TIMER_SIGIL_PREFIX='' INVOCATIONMESSAGE_TIMER_SIGIL_SUFFIX=''
    run invocationMessage --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "[45]"s"[56]"s${E}${E}OK"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "a failing silent command with --timer returns its exit status" {
    NO_OUTPUT="message: "
    run invocationMessage --message "$NO_OUTPUT" --timer 2 false

    [ $status -eq 1 ]
    [ "$output" = "$NO_OUTPUT" ]
}
