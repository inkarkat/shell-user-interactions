#!/usr/bin/env bats

load fixture

MESSAGE='testing it'
COMMAND_OUTPUT='command output'
SYMBOL_MESSAGE='%TIMESTAMP% now (%COUNT%)'
SYMBOL_OUTPUT='01-Apr-2020 11:06:40 now (0)'

@test "updating with a simple command that produces output clears before and restores the message afterwards" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run durationMessage --id ID --update echo "$COMMAND_OUTPUT"

    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}$COMMAND_OUTPUT
${MESSAGE}" ]
}

@test "updating with a simple command that produces output and a message with symbols" {
    durationMessage --id ID --initial --message "$SYMBOL_MESSAGE"
    let NOW+=1

    run durationMessage --id ID --update echo "$COMMAND_OUTPUT"

    [ $status -eq 0 ]
    [ "$output" = "${SYMBOL_OUTPUT//?/}${CLR}$COMMAND_OUTPUT
01-Apr-2020 11:06:41 now (1)" ]
}

@test "updating with a simple command that produces inline output and a message with symbols" {
    durationMessage --id ID --initial --message "$SYMBOL_MESSAGE"
    let NOW+=1

    run durationMessage --id ID --update printf "(${COMMAND_OUTPUT})"

    [ $status -eq 0 ]
    [ "$output" = "${SYMBOL_OUTPUT//?/}${CLR}(${COMMAND_OUTPUT})01-Apr-2020 11:06:41 now (1)" ]
}
