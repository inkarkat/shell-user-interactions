#!/usr/bin/env bats

load fixture

MESSAGE='testing it'
COMMAND_OUTPUT='command output'

setup()
{
    export DURATION_MESSAGE_SINK="${BATS_TMPDIR}/sink"
    : > "$DURATION_MESSAGE_SINK"
}

@test "initial call with message goes into sink" {
    run -0 durationMessage --id ID --initial --message "$MESSAGE"
    assert_output ''
    diff -y - --label expected "$DURATION_MESSAGE_SINK" <<<"$MESSAGE"
}

@test "updating a known ID with a message goes into sink after the initial message" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run -0 durationMessage --id ID --update --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output ''
    diff -y - --label expected "$DURATION_MESSAGE_SINK" <<EOF
$MESSAGE
01-Apr-2020 11:06:40: testing 1 for 00:00
EOF
}

@test "updating with a simple command goes into sink after the initial message" {
    durationMessage --id ID --initial --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'

    run -0 durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    assert_output "$COMMAND_OUTPUT"
    diff -y - --label expected "$DURATION_MESSAGE_SINK" <<'EOF'
01-Apr-2020 11:06:40: testing 0 for 00:00
01-Apr-2020 11:06:40: testing 1 for 00:00
EOF
}

@test "updating with a simple command twice and finishing goes into sink after the initial message" {
    durationMessage --id ID --initial --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'

    durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    durationMessage --id ID --update echo "$COMMAND_OUTPUT"
    durationMessage --id ID --finish

    diff -y - --label expected "$DURATION_MESSAGE_SINK" <<'EOF'
01-Apr-2020 11:06:40: testing 0 for 00:00
01-Apr-2020 11:06:40: testing 1 for 00:00
01-Apr-2020 11:06:40: testing 2 for 00:00
EOF
}
