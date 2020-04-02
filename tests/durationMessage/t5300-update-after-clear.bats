#!/usr/bin/env bats

load fixture

@test "updating after clear prints the whole message again" {
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --clear

    run durationMessage --id ID --update
    [ $status -eq 0 ]
    [ "$output" = 'testing it' ]
}

@test "updating with update message after clear prints the whole message again" {
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --clear

    run durationMessage --id ID --update --update-message ', try %COUNT%'
    [ $status -eq 0 ]
    [ "$output" = 'testing it, try 1' ]
}

@test "updating again with update message after clear prints the whole message again" {
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --update --update-message ', try %COUNT%'
    durationMessage --id ID --clear

    run durationMessage --id ID --update --update-message ', try %COUNT%'
    [ $status -eq 0 ]
    [ "$output" = 'testing it, try 2' ]
}

@test "updating with update message after clear prints the whole message again, then only the update message itself" {
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --clear

    run durationMessage --id ID --update --update-message ', try %COUNT%'
    [ $status -eq 0 ]
    [ "$output" = 'testing it, try 1' ]

    run durationMessage --id ID --update --update-message ', try %COUNT%'
    [ $status -eq 0 ]
    [ "$output" = ", try 2${CLR}" ]
}
