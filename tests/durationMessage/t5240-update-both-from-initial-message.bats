#!/usr/bin/env bats

load fixture

@test "immediately updating with both message and update message passed to initial updates the message and appends the update message" {
    durationMessage --id ID --initial --message 'starting it' --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'

    run durationMessage --id ID --message 'testing it' --update
    [ $status -eq 0 ]
    [ "$output" = "testing it, 01-Apr-2020 11:06:40: testing 1 for 00:00${CLR}" ]
}

@test "updating with both message and update message passed to initial after some time updates the message and appends the update message" {
    durationMessage --id ID --initial --message 'starting it' --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    let NOW+=122

    run durationMessage --id ID --update --message 'testing it'
    [ $status -eq 0 ]
    [ "$output" = "testing it, 01-Apr-2020 11:08:42: testing 1 for 02:02${CLR}" ]

    let NOW+=1

    run durationMessage --id ID --update
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:08:43: testing 2 for 02:03${CLR}" ]
}

@test "an previous update message is recalled on subsequent updates" {
    durationMessage --id ID --initial --message 'testing it'
    let NOW+=122

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:08:43: testing 2 for 02:03${CLR}" ]
}

@test "an previous update message can be cleared by passing an empty argument" {
    durationMessage --id ID --initial --message 'testing it'
    let NOW+=122

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update --update-message ''
    [ $status -eq 0 ]
    [ "$output" = "${CLR}" ]
}
