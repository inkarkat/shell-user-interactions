#!/usr/bin/env bats

load fixture

@test "immediately finishing a known ID with a message containing symbols" {
    durationMessage --id ID --initial

    run durationMessage --id ID --finish --message '%TIMESTAMP%: tested %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = '01-Apr-2020 11:06:40: tested 1 for 00:00' ]
}

@test "finishing a known ID with a message containing symbols after some time" {
    durationMessage --id ID --initial
    let NOW+=122

    run durationMessage --id ID --finish --message '%TIMESTAMP%: tested %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = '01-Apr-2020 11:08:42: tested 1 for 02:02' ]
}

@test "finishing with unavailable sink returns 1 two times, third finishing will replace message and update count" {
    durationMessage --id ID --initial --message 'testing it'
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --finish --message 'we are not done yet'
    [ $status -eq 1 ]
    DURATION_MESSAGE_SINK=/dev/full run durationMessage --id ID --finish --message 'we are not done yet'
    [ $status -eq 1 ]

    run durationMessage --id ID --finish --message 'we are done on %COUNT%. try'
    [ $status -eq 0 ]
    [ "$output" = "${CLR}we are done on 3. try" ]
}
