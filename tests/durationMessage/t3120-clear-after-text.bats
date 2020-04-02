#!/usr/bin/env bats

load fixture

durationMessageWrapper()
{
    printf 'a prefix:'
    durationMessage --id ID --initial --message 'testing it'
    durationMessage --id ID --clear
}

@test "clearing after existing text in a line keeps that text" {
    run durationMessageWrapper
    [ "$output" = "a prefix:testing it${CLR}" ]
}
