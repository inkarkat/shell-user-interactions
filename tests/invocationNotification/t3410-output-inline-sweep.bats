#!/usr/bin/env bats

load overlay
load inline-sink

@test "multi-line output from the command is individually appended / error output sweeps and final sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-sweep-stderr --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: stdout [ -* ]${N}${R}message: stdout again [  -*]${N}${R}message: OK${N}"
}

@test "single-line output from the command is individually appended / error output sweeps and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-sweep-stderr --clear all --command "$ECHO_COMMAND"
    assert_output 'stdout'
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

    assert_success
    assert_output - <<'EOF'
foo
second
third argument
immediate fourth
foo
last
EOF
    assert_sink "${R}message: ${N}${R}message: foo [*   ]${N}${R}message: foo [-*  ]${N}${R}message: foo [ -* ]${N}${R}message: foo [  -*]${N}${R}message: second [   *]${N}${R}message: second [  *-]${N}${R}message: third argument [ *- ]${N}${R}message: immediate fourth [*-  ]${N}${R}message: immediate fourth [*   ]${N}${R}message: immediate fourth [-*  ]${N}${R}message: immediate fourth [ -* ]${N}${R}message: foo [  -*]${N}${R}message: foo [   *]${N}${R}message: last [  *-]${N}${R}message: last${N}"
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

    assert_success
    assert_output - <<'EOF'
foo
second
third argument
immediate fourth
foo
last
EOF
    assert_sink "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: [ -* ]${N}${R}message: [  -*]${N}${R}message: foo [   *]${N}${R}message: foo [  *-]${N}${R}message: foo [ *- ]${N}${R}message: foo [*-  ]${N}${R}message: second [*   ]${N}${R}message: second [-*  ]${N}${R}message: third argument [ -* ]${N}${R}message: immediate fourth [  -*]${N}${R}message: immediate fourth [   *]${N}${R}message: immediate fourth [  *-]${N}${R}message: immediate fourth [ *- ]${N}${R}message: foo [*-  ]${N}${R}message: foo [*   ]${N}${R}message: last [-*  ]${N}${R}message: last [ -* ]${N}${R}message: last${N}"
}

@test "a failing silent command with --inline-sweep-stderr returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --timespan 0 --inline-sweep-stderr false
}
