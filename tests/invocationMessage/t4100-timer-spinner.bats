#!/usr/bin/env bats

load fixture
load timer

@test "print duration every two seconds and error output powers a spinner" {
    run invocationMessage --message 'message: ' --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "(1s\ /1s\ "${ERASE_TO_END}"-|/-[12]s\ |/[1]s\ -[12]s\ "${ERASE_TO_END}")"\\"[234]"s ${ERASE_TO_END}|"[345]"s ${ERASE_TO_END}|"[56]"s ${ERASE_TO_END}/"[56]"s ${ERASE_TO_END}- "$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "(1s\ /1s\ "${ERASE_TO_END}"-|/-[12]s\ |/[1]s\ -[12]s\ "${ERASE_TO_END}")"\\"[234]"s ${ERASE_TO_END}|"[345]"s ${ERASE_TO_END}|"[56]"s ${ERASE_TO_END}/"[56]"s ${ERASE_TO_END}-${ERASE_TO_END}OK ("[67]"s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "first print duration every two seconds and error output powers a spinner and then sigil" {
    run invocationMessage --message 'message: ' --success OK --timer 2 --timespan 0 --spinner-stderr --command "$SLEEP_FIRST_COMMAND"

    [ $status -eq 0 ]
    [[ "$output" =~ ^"message: "[23]"s /"[45]"s ${ERASE_TO_END}/"[45]"s ${ERASE_TO_END}/"[56]"s ${ERASE_TO_END}-"("6s ${ERASE_TO_END}\\")?"${ERASE_TO_END}OK ("[67]"s)"$ ]]  || echo "$output" | trcontrols | failThis prefix \# >&3
}

@test "timer and then spin" {
    run invocationMessage --timespan 0 --spinner-stderr --timer 2 --success YES -m 'just a test: ' -c '{ sleep 3; echo one; sleep 1; echo two; sleep 1; echo three; sleep 1; echo four; sleep 1; echo >&2 X1; sleep 1; echo >&2 X2 ; sleep 1; echo >&2 X3; sleep 1; echo >&2 X4; sleep 1; echo five; sleep 1; echo six; sleep 1; echo seven; sleep 1; }'

    [ $status -eq 0 ]
    [[ "$output" =~ ^"just a test: 2s /one
"("4s ${ERASE_TO_END}/")?"two
"("4s ${ERASE_TO_END}/")?"three
"("6s ${ERASE_TO_END}/")?"four
"("6s ${ERASE_TO_END}/")?"7s ${ERASE_TO_END}/8s ${ERASE_TO_END}-8s ${ERASE_TO_END}\10s ${ERASE_TO_END}\five
six
12s ${ERASE_TO_END}|seven
14s ${ERASE_TO_END}|${ERASE_TO_END}YES (14s)"$ ]] || echo "$output" | trcontrols | failThis prefix \# >&3
}
