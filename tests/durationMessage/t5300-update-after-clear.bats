#!/usr/bin/env bats

load fixture

MESSAGE='testing it'
UPDATE_MESSAGE=', try %COUNT%'

@test "updating after clear prints the whole message again" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear

    run -0 durationMessage --id ID --update
    assert_control_output "$MESSAGE"
}

@test "updating with update message after clear prints the whole message again" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear

    run -0 durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    assert_control_output 'testing it, try 1'
}

@test "updating again with update message after clear prints the whole message again" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    durationMessage --id ID --clear

    run -0 durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    assert_control_output 'testing it, try 2'
}

@test "updating with update message after clear prints the whole message again, then only the update message itself" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    durationMessage --id ID --clear --inline-always

    UPDATE_OUTPUT=', try 1'
    run -0 durationMessage --id ID --update --inline-always --update-message "$UPDATE_MESSAGE"
    assert_control_output "testing it${UPDATE_OUTPUT}"

    run -0 durationMessage --id ID --update --inline-always --update-message "$UPDATE_MESSAGE"
    assert_control_output "${UPDATE_OUTPUT//?/}, try 2${CLR}"
}
