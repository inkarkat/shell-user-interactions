#!/usr/bin/env bats

load fixture

@test "updating with a simple command that produces output clears before and restores the message afterwards" {
    durationMessage --id ID --initial --message 'testing it'

    run durationMessage --id ID --update echo 'command output'

    [ $status -eq 0 ]
    [ "$output" = "${CLR}command output
testing it" ]
}

@test "updating with a simple command that produces output and a message with symbols" {
    durationMessage --id ID --initial --message '%TIMESTAMP% now (%COUNT%)'
    let NOW+=1

    run durationMessage --id ID --update echo 'command output'

    [ $status -eq 0 ]
    [ "$output" = "${CLR}command output
01-Apr-2020 11:06:41 now (1)" ]
}

@test "updating with a simple command that produces inline output and a message with symbols" {
    durationMessage --id ID --initial --message '%TIMESTAMP% now (%COUNT%)'
    let NOW+=1

    run durationMessage --id ID --update printf '(command output)'

    [ $status -eq 0 ]
    [ "$output" = "${CLR}(command output)01-Apr-2020 11:06:41 now (1)" ]
}
