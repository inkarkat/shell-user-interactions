#!/usr/bin/env bats

load fixture

START_MESSAGE='starting it'
MESSAGE='testing it'
UPDATE_MESSAGE='%TIMESTAMP%: testing %COUNT% for %DURATION%'

@test "updating command with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial
    let NOW+=122

    run durationMessage --id ID --update --update-message "$UPDATE_MESSAGE" -- echo 'command1 output'
    OUTPUT='01-Apr-2020 11:08:42: testing 1 for 02:02'
    [ $status -eq 0 ]
    [ "$output" = "command1 output
${OUTPUT}" ]

    let NOW+=1

    run durationMessage --id ID --update --inline-always --update-message "$UPDATE_MESSAGE" -- echo 'command2 output'
    [ $status -eq 0 ]
    [ "$output" = "${OUTPUT//?/}${CLR}command2 output
01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}

@test "updating an original message and command with an update message containing symbols after some time increments times and counts" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    let NOW+=122

    OUTPUT=', 01-Apr-2020 11:08:42: testing 1 for 02:02'
    run durationMessage --id ID --update --inline-always --update-message ", $UPDATE_MESSAGE" -- echo "command1 output"
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${CLR}command1 output
${MESSAGE}${OUTPUT}" ]

    let NOW+=1

    run durationMessage --id ID --update --inline-always --update-message ", $UPDATE_MESSAGE" -- echo 'command2 output'
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${OUTPUT//?/}${CLR}command2 output
${MESSAGE}, 01-Apr-2020 11:08:43: testing 2 for 02:03" ]
}

@test "updating command with both message and update message after some time updates the message and appends the update message" {
    durationMessage --id ID --initial --inline-always --message "$START_MESSAGE"
    let NOW+=122

    OUTPUT=', 01-Apr-2020 11:08:42: testing 1 for 02:02'
    run durationMessage --id ID --update --inline-always --message "$MESSAGE" --update-message ", $UPDATE_MESSAGE" -- echo 'command1 output'
    [ $status -eq 0 ]
    [ "$output" = "${START_MESSAGE//?/}${CLR}command1 output
${MESSAGE}${OUTPUT}" ]

    let NOW+=1

    OUTPUT=', 01-Apr-2020 11:08:43: testing 2 for 02:03'
    run durationMessage --id ID --update --inline-always --update-message ", $UPDATE_MESSAGE" -- echo 'command2 output'
    [ $status -eq 0 ]
    [ "$output" = "${MESSAGE//?/}${OUTPUT//?/}${CLR}command2 output
${MESSAGE}${OUTPUT}" ]
}
