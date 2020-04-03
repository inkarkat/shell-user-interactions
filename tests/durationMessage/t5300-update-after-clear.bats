#!/usr/bin/env bats

load fixture

MESSAGE='testing it'
UPDATE_MESSAGE=', try %COUNT%'

@test "updating after clear prints the whole message again" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear

    run durationMessage --id ID --update
    [ $status -eq 0 ]
    [ "$output" = "$MESSAGE" ]
}

@test "updating with update message after clear prints the whole message again" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear

    run durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    [ $status -eq 0 ]
    [ "$output" = 'testing it, try 1' ]
}

@test "updating again with update message after clear prints the whole message again" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    durationMessage --id ID --clear

    run durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    [ $status -eq 0 ]
    [ "$output" = 'testing it, try 2' ]
}

@test "updating with update message after clear prints the whole message again, then only the update message itself" {
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear

    UPDATE_OUTPUT=', try 1'
    run durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    [ $status -eq 0 ]
    [ "$output" = "testing it${UPDATE_OUTPUT}" ]

    run durationMessage --id ID --update --update-message "$UPDATE_MESSAGE"
    [ $status -eq 0 ]
    [ "$output" = "${UPDATE_OUTPUT//?/}, try 2${CLR}" ]
}
