#!/usr/bin/env bats

load fixture

@test "count symbol is expanded to 0 in initial message" {
    run -0 durationMessage --id ID --initial --message 'testing (%COUNT%)'
    assert_output 'testing (0)'
}

@test "duration symbol is expanded to 00:00 in initial message" {
    run -0 durationMessage --id ID --initial --message 'testing %DURATION% running'
    assert_output 'testing 00:00 running'
}

@test "timestamp symbol is expanded in initial message" {
    run -0 durationMessage --id ID --initial --message '%TIMESTAMP%-testing it'
    assert_output '01-Apr-2020 11:06:40-testing it'
}

@test "various and duplicate symbols are expanded in initial message" {
    run -0 durationMessage --id ID --initial --message '%COUNT%:%TIMESTAMP%:%DURATION%: testing it since %TIMESTAMP% for %DURATION% (%COUNT%/%COUNT%)'
    assert_output '0:01-Apr-2020 11:06:40:00:00: testing it since 01-Apr-2020 11:06:40 for 00:00 (0/0)'
}
