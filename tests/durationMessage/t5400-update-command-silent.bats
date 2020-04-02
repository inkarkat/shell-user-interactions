#!/usr/bin/env bats

load fixture
load marker

@test "updating with a simple silent command executes it once" {
    run durationMessage --id ID --update --silent-command "${APPEND_COMMAND_ARGUMENTS[@]}" "$MARKER"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_marker_calls -eq 1
}

@test "updating with a silent command-line executes it once" {
    run durationMessage --id ID --update --silent-command --command "$APPEND_COMMANDLINE '$MARKER'"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_marker_calls -eq 1
}

@test "updating with two silent command-lines executes it twice" {
    run durationMessage --id ID --update --silent-command --command "$APPEND_COMMANDLINE '$MARKER'" --command "$APPEND_COMMANDLINE '$MARKER'"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_marker_calls -eq 2
}

@test "updating with silent simple command and command-line executes both" {
    run durationMessage --id ID --update --silent-command --command "$APPEND_COMMANDLINE '$MARKER'" -- "${APPEND_COMMAND_ARGUMENTS[@]}" "$MARKER"

    [ $status -eq 0 ]
    [ "$output" = "" ]
    assert_marker_calls -eq 2
}
