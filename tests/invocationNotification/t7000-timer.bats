#!/usr/bin/env bats

load fixture
load overlay
load timer

@test "print duration every two seconds" {
    run invocationNotification --to overlay --message 'message: ' --timer 2 sleep 5

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}${R}message: "[23]"s${N}${R}message: "[45]"s${N}${R}message: "[56]"s${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds, ignoring stderr" {
    run invocationNotification --to overlay --message 'message: ' --timer 2 --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"${R}message: ${N}first
"(second
)?"${R}message: 1s${N}"(second
)?"${R}message: "[234]"s${N}"("${R}message: "[45]"s${N}")?"third
"("${R}message: "[45]"s${N}")?"fourth
${R}message: "[56]"s${N}fifth
${R}message: "[67]"s${N}"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds is suppressed with initial delay of 3 seconds due to shortness" {
    run invocationNotification --to overlay --message 'message: ' --initial-delay 3 --timer 2 sleep 2.5

    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration" {
skip
    run invocationNotification --to overlay --message 'message: ' --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 4s5s${E}" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and then includes final duration in sigil" {
skip
    run invocationNotification --to overlay --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [ "$output" = "message: 4s5s${E}${E}OK (5s)" ] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds, with initial delay of 3 seconds, skips the first duration, and inclusion of final duration in sigil is suppressed by clearing the prefix and suffix configuration" {
skip
    export INVOCATIONMESSAGE_TIMER_SIGIL_PREFIX='' INVOCATIONMESSAGE_TIMER_SIGIL_SUFFIX=''
    run invocationNotification --to overlay --message 'message: ' --success OK --initial-delay 3 --timer 2 sleep 5

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "[45]"s"[56]"s${E}${E}OK"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
