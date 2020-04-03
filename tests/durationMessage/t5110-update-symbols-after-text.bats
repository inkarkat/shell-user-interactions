#!/usr/bin/env bats

load fixture

durationMessageWrapper()
{
    printf 'a prefix:'
    durationMessage --id ID --initial --message '%TIMESTAMP% now (%COUNT%)'
    let NOW+=10
    durationMessage --id ID --update
}

@test "updating symbols in message after existing text in a line keeps that text" {
    OUTPUT='01-Apr-2020 11:06:40 now (0)'
    run durationMessageWrapper
    [ "$output" = "a prefix:${OUTPUT}${OUTPUT//?/}01-Apr-2020 11:06:50 now (1)${CLR}" ]
}
