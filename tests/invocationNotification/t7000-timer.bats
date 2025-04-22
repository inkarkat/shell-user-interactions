#!/usr/bin/env bats

load overlay
load ../timer

@test "print duration every two seconds" {
    run -0 invocationNotification --to overlay --message 'message: ' --timer 2 sleep 5
    [[ "$output" =~ ^"${R}message: ${N}${R}message: "[23]"s${N}${R}message: "[45]"s${N}${R}message: "[56]"s${N}"$ ]] || dump_output
}

@test "print duration every two seconds, ignoring stderr" {
    run -0 invocationNotification --to overlay --message 'message: ' --timer 2 --command "$MULTI_LINE_COMMAND"
    [[ "$output" =~ ^"${R}message: ${N}"(first
(second
)?)?"${R}message: 1s${N}"((first
)?second
)?"${R}message: "[234]"s${N}"("${R}message: "[45]"s${N}")?"third
"("${R}message: "[45]"s${N}")?"fourth
${R}message: "[56]"s${N}fifth
${R}message: "[67]"s${N}"$ ]] || dump_output
}

@test "print duration every two seconds is suppressed with initial delay of 3 seconds due to shortness" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 3 --timer 2 sleep 2.5
    assert_output ''
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration" {
    run -0 invocationNotification --to overlay --message 'message: ' --initial-delay 3 --timer 2 sleep 5
    [[ "$output" =~ ^("${R}message: "[45]"s${N}")?"${R}message: "[56]"s${N}"$ ]] || dump_output
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and then includes final duration in sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5
    [[ "$output" =~ ^("${R}message: 4s${N}")?"${R}message: 5s${N}${R}message: OK (5s)${N}"$ ]] || dump_output
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and inclusion of final duration in sigil is suppressed by clearing the prefix and suffix configuration" {
    export INVOCATIONNOTIFICATION_TIMER_SIGIL_PREFIX='' INVOCATIONNOTIFICATION_TIMER_SIGIL_SUFFIX=''
    run -0 invocationNotification --to overlay --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5
    [[ "$output" =~ ^"${R}message: "[45]"s${N}${R}message: "[56]"s${N}${R}message: OK${N}"$ ]] || dump_output
}

@test "a failing silent command wiht --timer returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --timer 2 false
}
