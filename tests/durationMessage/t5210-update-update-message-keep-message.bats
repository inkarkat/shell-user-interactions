#!/usr/bin/env bats

load fixture

@test "immediately updating a known ID with an update message containing symbols" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:06:40: testing 1 for 00:00" ]
}

@test "immediately updating a known ID with an update message containing symbols twice increments count" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:06:40: testing 1 for 00:00" ]

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:06:40: testing 2 for 00:00" ]

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:06:40: testing 3 for 00:00" ]
}

@test "updating a known ID with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial --message 'testing it'
    let NOW+=122

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, 01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}

@test "updating with unavailable sink returns 1 two times, third updating will replace update message and update count" {
    durationMessage --id ID --initial --message 'testing it'
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update --update-message ', we are not testing yet'
    [ $status -eq 1 ]
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --update --update-message ', we are not testing yet'
    [ $status -eq 1 ]

    run durationMessage --id ID --update --update-message ', we are testing with %COUNT%. try'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}testing it, we are testing with 3. try" ]
}
