#!/usr/bin/env bats

load fixture
load inline
load inline-sink

@test "multi-line output from the command is individually appended / error output sweeps and final sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-sweep-stderr --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "message: [*   ][-*  ]${S}stdout [ -* ]${RE}stdout again [  -*]${RE}OK"
}

@test "single-line output from the command is individually appended / error output sweeps and then cleared" {
    run invocationMessage --message 'message: ' --inline-sweep-stderr --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: stdout [*   ]${RE}"
}

@test "mixed longer output starting and ending with stdout sweeping" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-sweep-stderr --command "
${MS}echo foo;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo second;
${MS}echo >&2 x;
${MS}echo third argument;
${MS}echo immediate fourth;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo foo;
${MS}echo >&2 x;
${MS}echo last;
"

    [ $status -eq 0 ]
    [ "$output" = "foo
second
third argument
immediate fourth
foo
last" ]
    assert_sink "message: ${S}foo [*   ][-*  ][ -* ][  -*]${RE}second [   *][  *-]${RE}third argument [ *- ]${RE}immediate fourth [*-  ][*   ][-*  ][ -* ]${RE}foo [  -*][   *]${RE}last [  *-]      "
}

@test "mixed longer output starting and ending with stderr sweeping" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-sweep-stderr --command "
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo foo;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo second;
${MS}echo >&2 x;
${MS}echo third argument;
${MS}echo immediate fourth;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo >&2 x;
${MS}echo foo;
${MS}echo >&2 x;
${MS}echo last;
${MS}echo >&2 x;
"

    [ $status -eq 0 ]
    [ "$output" = "foo
second
third argument
immediate fourth
foo
last" ]
    assert_sink "message: [*   ][-*  ][ -* ][  -*]${S}foo [   *][  *-][ *- ][*-  ]${RE}second [*   ][-*  ]${RE}third argument [ -* ]${RE}immediate fourth [  -*][   *][  *-][ *- ]${RE}foo [*-  ][*   ]${RE}last [-*  ][ -* ]      "
}
