#!/usr/bin/env bats

load fixture

@test "updating command with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial
    let NOW+=122

    run durationMessage --id ID --update --update-message '%TIMESTAMP%: testing %COUNT% for %DURATION%' -- echo 'command1 output'
    [ $status -eq 0 ]
    [ "$output" = 'command1 output
01-Apr-2020 11:08:42: testing 1 for 02:02' ]

    let NOW+=1

    run durationMessage --id ID --update --update-message '%TIMESTAMP%: testing %COUNT% for %DURATION%' -- echo 'command2 output'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}command2 output
01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}

@test "updating an original message and command with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial --message 'testing it'
    let NOW+=122

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%' -- echo 'command1 output'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}command1 output
testing it, 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%' -- echo 'command2 output'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}command2 output
testing it, 01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}

@test "updating command with both message and update message after some time updates the message and appends the update message" {
    durationMessage --id ID --initial --message 'starting it'
    let NOW+=122

    run durationMessage --id ID --update --message 'testing it' --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%' -- echo 'command1 output'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}command1 output
testing it, 01-Apr-2020 11:08:42: testing 1 for 02:02" ]

    let NOW+=1

    run durationMessage --id ID --update --update-message ', %TIMESTAMP%: testing %COUNT% for %DURATION%' -- echo 'command2 output'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}command2 output
testing it, 01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}
