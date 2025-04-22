#!/usr/bin/env bats

load fixture

MESSAGE='testing it'
COMMAND_OUTPUT='command output'
SYMBOL_MESSAGE='%TIMESTAMP% now (%COUNT%)'
SYMBOL_OUTPUT='01-Apr-2020 11:06:40 now (0)'

@test "updating with a simple command that produces output clears before and restores the message afterwards" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    run -0 durationMessage --id ID --update --inline-always echo "$COMMAND_OUTPUT"
    assert_control_output - <<EOF
${MESSAGE//?/}${CLR}$COMMAND_OUTPUT
${MESSAGE}
EOF
}

@test "updating with a simple command that produces output and a message with symbols" {
    durationMessage --id ID --initial --inline-always --message "$SYMBOL_MESSAGE"
    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always echo "$COMMAND_OUTPUT"
    assert_control_output - <<EOF
${SYMBOL_OUTPUT//?/}${CLR}$COMMAND_OUTPUT
01-Apr-2020 11:06:41 now (1)
EOF
}

@test "updating with a simple command that produces inline output and a message with symbols" {
    durationMessage --id ID --initial --inline-always --message "$SYMBOL_MESSAGE"
    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always printf "(${COMMAND_OUTPUT})"
    assert_control_output "${SYMBOL_OUTPUT//?/}${CLR}(${COMMAND_OUTPUT})01-Apr-2020 11:06:41 now (1)"
}
