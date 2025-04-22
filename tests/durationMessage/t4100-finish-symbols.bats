#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

@test "immediately finishing a known ID with a message containing symbols" {
    durationMessage --id ID --initial

    run -0 durationMessage --id ID --finish --message '%TIMESTAMP%: tested %COUNT% for %DURATION%'
    assert_control_output '01-Apr-2020 11:06:40: tested 1 for 00:00'
}

@test "finishing a known ID with a message containing symbols after some time" {
    durationMessage --id ID --initial
    let NOW+=122

    run -0 durationMessage --id ID --finish --message '%TIMESTAMP%: tested %COUNT% for %DURATION%'
    assert_control_output '01-Apr-2020 11:08:42: tested 1 for 02:02'
}

@test "finishing with unavailable sink returns 1 two times, third finishing will replace message and update count" {
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --finish --inline-always --message 'we are not done yet'
    DURATION_MESSAGE_SINK=/dev/full run -1 durationMessage --id ID --finish --inline-always --message 'we are not done yet'

    run -0 durationMessage --id ID --finish --inline-always --message 'we are done on %COUNT%. try'
    assert_control_output "${MESSAGE//?/}${CLR}we are done on 3. try"
}
