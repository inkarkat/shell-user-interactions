#!/usr/bin/env bats

load fixture

@test "immediately finishing a known ID with a message containing symbols" {
    durationMessage --id ID --initial

    run durationMessage --id ID --finish --message '%TIMESTAMP%: tested %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = '01-Apr-2020 11:06:40: tested 0 for 00:00' ]
}

@test "finishing a known ID with a message containing symbols after some time" {
    durationMessage --id ID --initial
    let NOW+=122

    run durationMessage --id ID --finish --message '%TIMESTAMP%: tested %COUNT% for %DURATION%'
    [ $status -eq 0 ]
    [ "$output" = '01-Apr-2020 11:08:42: tested 0 for 02:02' ]
}
