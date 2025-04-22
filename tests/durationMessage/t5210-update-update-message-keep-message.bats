#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

@test "immediately updating with an update message containing symbols" {
    durationMessage --id ID --initial --message "$MESSAGE"

    run -0 durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output ", 01-Apr-2020 11:06:40: testing 1 for 00:00"
}

@test "immediately updating with an update message containing symbols twice increments count" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"

    OUTPUT=', 01-Apr-2020 11:06:40: testing 1 for 00:00'
    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "$OUTPUT"

    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "${OUTPUT//?/}, 01-Apr-2020 11:06:40: testing 2 for 00:00${CLR}"

    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "${OUTPUT//?/}, 01-Apr-2020 11:06:40: testing 3 for 00:00${CLR}"
}

@test "updating with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    let NOW+=122

    OUTPUT=', 01-Apr-2020 11:08:42: testing 1 for 02:02'
    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "$OUTPUT"

    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "${OUTPUT//?/}, 01-Apr-2020 11:08:43: testing 2 for 02:03${CLR}"
}
