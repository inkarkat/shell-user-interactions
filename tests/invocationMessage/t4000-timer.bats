#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds" {
    run invocationMessage --message 'message: ' --timer 2 sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 2s4s${ERASE_TO_END}" ]
}

@test "print duration every two seconds, ignoring stderr" {
    run invocationMessage --message 'message: ' --timer 2 --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: 3s6s${ERASE_TO_END}first
second
third
fourth
fifth" ] || [ "$output" = "message: 2s4s${ERASE_TO_END}6s${ERASE_TO_END}first
second
third
fourth
fifth" ]
}

@test "print duration every two seconds is suppressed with initial delay of 3 seconds due to shortness" {
    run invocationMessage --message 'message: ' --initial-delay 3 --timer 2 sleep 2.5

    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration" {
    run invocationMessage --message 'message: ' --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 4s" ]
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and then includes final duration in sigil" {
    run invocationMessage --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 4s${ERASE_TO_END}OK (5s)" ]
}
