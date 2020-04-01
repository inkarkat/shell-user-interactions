#!/usr/bin/env bats

load fixture

@test "immediately updating with an update message containing symbols" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:06:40: testing 1 for 00:00" ]
}

@test "immediately updating with an update message containing symbols twice increments count" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:06:40: testing 1 for 00:00" ]

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}, 01-Apr-2020 11:06:40: testing 2 for 00:00" ]

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}, 01-Apr-2020 11:06:40: testing 3 for 00:00" ]
}

@test "updating with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial --message 'testing it'
    let NOW+=122

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = ", 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}, 01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}
