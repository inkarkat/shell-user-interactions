#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds" {
    run -0 invocationMessage --message 'message: ' --timer 2 sleep 5
    [[ "$output" =~ ^"message: "[23]"s"[45]"s${E}"[56]"s${E}"$ ]] || dump_output
}

@test "print duration every two seconds, ignoring stderr" {
    run -0 invocationMessage --message 'message: ' --timer 2 --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"message: 1s"[234]s"${E}"[45]s"${E}"[56]s"${E}"[67]s"${E}"("7s${E}")?"first
second
third
fourth
fifth"$ ]] || dump_output
}

@test "print duration every two seconds is suppressed with initial delay of 3 seconds due to shortness" {
    run -0 invocationMessage --message 'message: ' --initial-delay 3 --timer 2 sleep 2.5
    assert_control_output ''
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration" {
    run -0 invocationMessage --message 'message: ' --initial-delay 3 --timer 2 sleep 5
    [[ "$output" =~ ^"message: "[45]s(""[56]s"${E}")?$ ]] || dump_output
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and then includes final duration in sigil" {
    run -0 invocationMessage --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5
    assert_control_output "message: 4s5s${E}${E}OK (5s)" || dump_output
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and inclusion of final duration in sigil is suppressed by clearing the prefix and suffix configuration" {
    export INVOCATIONMESSAGE_TIMER_SIGIL_PREFIX='' INVOCATIONMESSAGE_TIMER_SIGIL_SUFFIX=''
    run -0 invocationMessage --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5
    [[ "$output" =~ ^"message: "[45]"s"[56]"s${E}${E}OK"$ ]] || dump_output
}

@test "a failing silent command with --timer returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --message "$NO_OUTPUT" --timer 2 false
    assert_control_output "$NO_OUTPUT"
}
