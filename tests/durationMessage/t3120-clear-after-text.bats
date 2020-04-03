#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

durationMessageWrapper()
{
    printf 'a prefix:'
    durationMessage --id ID --initial --message "$MESSAGE"
    durationMessage --id ID --clear
}

@test "clearing after existing text in a line keeps that text" {
    run durationMessageWrapper
    [ "$output" = "a prefix:testing it${MESSAGE//?/}${CLR}" ]
}
