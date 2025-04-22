#!/usr/bin/env bats

load fixture

MESSAGE='testing it'

durationMessageWrapper()
{
    printf 'a prefix:'
    durationMessage --id ID --initial --inline-always --message "$MESSAGE"
    durationMessage --id ID --clear --inline-always
}

@test "clearing after existing text in a line keeps that text" {
    run durationMessageWrapper
    assert_control_output "a prefix:testing it${MESSAGE//?/}${CLR}"
}
