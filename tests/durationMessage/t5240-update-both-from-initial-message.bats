#!/usr/bin/env bats

load fixture

START_MESSAGE='starting it'
MESSAGE='testing it'

@test "immediately updating with both message and update message passed to initial updates the message and appends the update message" {
    durationMessage --id ID --initial --inline-always --message "$START_MESSAGE" --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'

    run -0 durationMessage --id ID --message "$MESSAGE" --update --inline-always
    assert_control_output "${START_MESSAGE//?/}${MESSAGE}, 01-Apr-2020 11:06:40: testing 1 for 00:00${CLR}"
}

@test "updating with both message and update message passed to initial after some time updates the message and appends the update message" {
    durationMessage --id ID --initial --inline-always --message "$START_MESSAGE" --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    let NOW+=122

    UPDATE_OUTPUT=', 01-Apr-2020 11:08:42: testing 1 for 02:02'
    run -0 durationMessage --id ID --update --inline-always --message "$MESSAGE"
    assert_control_output "${START_MESSAGE//?/}${MESSAGE}${UPDATE_OUTPUT}${CLR}"

    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always
    assert_control_output "${UPDATE_OUTPUT//?/}, 01-Apr-2020 11:08:43: testing 2 for 02:03${CLR}"
}

@test "an previous update message is recalled on subsequent updates" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    let NOW+=122

    UPDATE_OUTPUT=', 01-Apr-2020 11:08:42: testing 1 for 02:02'
    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "$UPDATE_OUTPUT"

    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always
    assert_control_output "${UPDATE_OUTPUT//?/}, 01-Apr-2020 11:08:43: testing 2 for 02:03${CLR}"
}

@test "an previous update message can be cleared by passing an empty argument" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    let NOW+=122

    UPDATE_OUTPUT=', 01-Apr-2020 11:08:42: testing 1 for 02:02'
    run -0 durationMessage --id ID --update --inline-always --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    assert_control_output "$UPDATE_OUTPUT"

    let NOW+=1

    run -0 durationMessage --id ID --update --inline-always --update-message ''
    assert_control_output "${UPDATE_OUTPUT//?/}${CLR}"
}
