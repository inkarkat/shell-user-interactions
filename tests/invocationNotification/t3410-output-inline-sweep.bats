#!/usr/bin/env bats

load fixture
load overlay
load inline

@test "multi-line output from the command is individually appended / error output sweeps and final sigil" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-sweep-stderr --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: stdout [ -* ]${N}${R}message: stdout again [  -*]${N}${R}message: stdout again [   *]${N}${R}message: OK${N}"
}

@test "single-line output from the command is individually appended / error output sweeps and then cleared" {
    run invocationNotification --to overlay --message 'message: ' --inline-sweep-stderr --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${R}message: ${N}${R}message: stdout [*   ]${N}${C}"
}

@test "mixed longer output starting and ending with stdout sweeping" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-sweep-stderr --command "
${S}echo foo;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo second;
${S}echo >&2 x;
${S}echo third argument;
${S}echo immediate fourth;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo foo;
${S}echo >&2 x;
${S}echo last;
"

    [ $status -eq 0 ]
    [ "$output" = "foo
second
third argument
immediate fourth
foo
last" ]
    assert_sink "${R}message: ${N}${R}message: foo [*   ]${N}${R}message: foo [-*  ]${N}${R}message: foo [ -* ]${N}${R}message: foo [  -*]${N}${R}message: second [   *]${N}${R}message: second [  *-]${N}${R}message: third argument [ *- ]${N}${R}message: immediate fourth [*-  ]${N}${R}message: immediate fourth [*   ]${N}${R}message: immediate fourth [-*  ]${N}${R}message: immediate fourth [ -* ]${N}${R}message: foo [  -*]${N}${R}message: foo [   *]${N}${R}message: last [  *-]${N}${R}message: last [ *- ]${N}"
}

@test "mixed longer output starting and ending with stderr sweeping" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-sweep-stderr --command "
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo foo;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo second;
${S}echo >&2 x;
${S}echo third argument;
${S}echo immediate fourth;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo >&2 x;
${S}echo foo;
${S}echo >&2 x;
${S}echo last;
${S}echo >&2 x;
"

    [ $status -eq 0 ]
    [ "$output" = "foo
second
third argument
immediate fourth
foo
last" ]
    assert_sink "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: [ -* ]${N}${R}message: [  -*]${N}${R}message: foo [   *]${N}${R}message: foo [  *-]${N}${R}message: foo [ *- ]${N}${R}message: foo [*-  ]${N}${R}message: second [*   ]${N}${R}message: second [-*  ]${N}${R}message: third argument [ -* ]${N}${R}message: immediate fourth [  -*]${N}${R}message: immediate fourth [   *]${N}${R}message: immediate fourth [  *-]${N}${R}message: immediate fourth [ *- ]${N}${R}message: foo [*-  ]${N}${R}message: foo [*   ]${N}${R}message: last [-*  ]${N}${R}message: last [ -* ]${N}${R}message: last [  -*]${N}"
}
