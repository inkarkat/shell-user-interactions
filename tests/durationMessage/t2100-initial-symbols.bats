#!/usr/bin/env bats

load fixture

@test "count symbol is expanded to 0 in initial message" {
    run durationMessage --id ID --initial --message 'testing (%COUNT%)'
    [ $status -eq 0 ]
    [ "$output" = "testing (0)" ]
}

@test "duration symbol is expanded to 00:00 in initial message" {
    run durationMessage --id ID --initial --message 'testing %DURATION% running'
    [ $status -eq 0 ]
    [ "$output" = "testing 00:00 running" ]
}

@test "timestamp symbol is expanded in initial message" {
    run durationMessage --id ID --initial --message '%TIMESTAMP%-testing it'
    [ $status -eq 0 ]
    [ "$output" = "01-Apr-2020 11:06:40-testing it" ]
}
