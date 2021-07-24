#!/usr/bin/env bats

load fixture

MESSAGE='testing it'
COMMAND_OUTPUT='command output'

setup()
{
    export DURATION_MESSAGE_SINK="${BATS_TMPDIR}/sink"
    > "$DURATION_MESSAGE_SINK"
}

@test "initial call with message goes into sink" {
    run durationMessage --id ID --initial --message "$MESSAGE"
    [ $status -eq 0 ]
    [ "$output" = '' ]
    [ "$(cat "$DURATION_MESSAGE_SINK")" = "$MESSAGE" ]
}

@test "updating a known ID with a message goes into sink after the initial message" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run durationMessage --id ID --update --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = '' ]
    [ "$(cat "$DURATION_MESSAGE_SINK")" = "$MESSAGE
01-Apr-2020 11:06:40: testing 1 for 00:00" ]
}

@test "updating with a simple command goes into sink after the initial message" {
    durationMessage --id ID --initial --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'

    run durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    [ $status -eq 0 ]
    [ "$output" = "$COMMAND_OUTPUT" ]
    [ "$(cat "$DURATION_MESSAGE_SINK")" = '01-Apr-2020 11:06:40: testing 0 for 00:00
01-Apr-2020 11:06:40: testing 1 for 00:00' ]
}

@test "updating with a simple command twice and finishing goes into sink after the initial message" {
    durationMessage --id ID --initial --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'

    durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    durationMessage --id ID --finish

    [ "$(cat "$DURATION_MESSAGE_SINK")" = '01-Apr-2020 11:06:40: testing 0 for 00:00
01-Apr-2020 11:06:40: testing 1 for 00:00
01-Apr-2020 11:06:40: testing 2 for 00:00' ]
}
