#!/usr/bin/env bats

load fixture

@test "immediately updating with update message updates the symbols in the message and appends the update message" {
    durationMessage --id ID --initial --message '%TIMESTAMP% starting it'

    run -0 durationMessage --id ID --update --update-message ', testing %COUNT% for %DURATION%'
    assert_output ', testing 1 for 00:00'
}

@test "updating with update message after some time updates the symbols in the message and appends the update message" {
    durationMessage --id ID --initial --inline-always --message '%TIMESTAMP% starting it'
    let NOW+=122

    OUTPUT='01-Apr-2020 11:08:42 starting it'
    UPDATE_OUTPUT=', testing 1 for 02:02'
    run -0 durationMessage --id ID --update --inline-always --update-message ', testing %COUNT% for %DURATION%'
    assert_output "${OUTPUT//?/}01-Apr-2020 11:08:42 starting it${UPDATE_OUTPUT}${CLR}"

    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always --update-message ', testing %COUNT% for %DURATION%'
    assert_output "${OUTPUT//?/}${UPDATE_OUTPUT//?/}01-Apr-2020 11:08:43 starting it, testing 2 for 02:03${CLR}"
}
