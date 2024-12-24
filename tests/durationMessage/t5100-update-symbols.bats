#!/usr/bin/env bats

load fixture

@test "immediately updating a known ID with a message containing symbols" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --update --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output '01-Apr-2020 11:06:40: testing 1 for 00:00'
}

@test "immediately updating a known ID with a message containing symbols twice increments count" {
    durationMessage --id ID --initial --inline-always

    OUTPUT='01-Apr-2020 11:06:40: testing 1 for 00:00'
    run -0 durationMessage --id ID --update --inline-always --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output "$OUTPUT"

    run -0 durationMessage --id ID --update --inline-always --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output "${OUTPUT//?/}01-Apr-2020 11:06:40: testing 2 for 00:00${CLR}"

    run -0 durationMessage --id ID --update --inline-always --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output "${OUTPUT//?/}01-Apr-2020 11:06:40: testing 3 for 00:00${CLR}"
}

@test "updating a known ID with a message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial --inline-always
    let NOW+=122

    OUTPUT='01-Apr-2020 11:08:42: testing 1 for 02:02'
    run -0 durationMessage --id ID --update --inline-always --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output "$OUTPUT"

    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always --message '%TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_output "${OUTPUT//?/}01-Apr-2020 11:08:43: testing 2 for 02:03${CLR}"
}

@test "updating with unavailable sink returns 1 two times, third updating will replace message and update count" {
    MESSAGE='testing it'
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --update --inline-always --message 'we are not testing yet'
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --update --inline-always --message 'we are not testing yet'

    run -0 durationMessage --id ID --update --inline-always --message 'we are testing with %COUNT%. try'
    assert_output "${MESSAGE//?/}we are testing with 3. try${CLR}"
}
