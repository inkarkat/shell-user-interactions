#!/usr/bin/env bats

load fixture

@test "immediately updating with both message and update message updates the message and appends the update message" {
    durationMessage --id ID --initial --message 'starting it'

    run durationMessage --id ID --message 'testing it' --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:06:40: testing 1 for 00:00" ]
}

@test "updating with both message and update message after some time updates the message and appends the update message" {
    durationMessage --id ID --initial --message 'starting it'
    let NOW+=122

    run durationMessage --id ID --update --message 'testing it' --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}, 01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}
