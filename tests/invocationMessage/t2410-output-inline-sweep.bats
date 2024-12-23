#!/usr/bin/env bats

load inline
load inline-sink

@test "multi-line output from the command is individually appended / error output sweeps and final sigil" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-sweep-stderr --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "message: [*   ][-*  ]${S}stdout [ -* ]${RE}stdout again [  -*]${RE}OK"
}

@test "single-line output from the command is individually appended / error output sweeps and then cleared" {
    run -0 invocationMessage --message 'message: ' --inline-sweep-stderr --clear all --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${S}message: stdout [*   ]${RE}"
}

@test "mixed longer output starting and ending with stdout sweeping" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-sweep-stderr --command "
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
    assert_output - <<'EOF'
foo
second
third argument
immediate fourth
foo
last
EOF
    assert_sink "message: ${S}foo [*   ][-*  ][ -* ][  -*]${RE}second [   *][  *-]${RE}third argument [ *- ]${RE}immediate fourth [*-  ][*   ][-*  ][ -* ]${RE}foo [  -*][   *]${RE}last [  *-]      "
}

@test "mixed longer output starting and ending with stderr sweeping" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-sweep-stderr --command "
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
    assert_output - <<'EOF'
foo
second
third argument
immediate fourth
foo
last
EOF
    assert_sink "message: [*   ][-*  ][ -* ][  -*]${S}foo [   *][  *-][ *- ][*-  ]${RE}second [*   ][-*  ]${RE}third argument [ -* ]${RE}immediate fourth [  -*][   *][  *-][ *- ]${RE}foo [*-  ][*   ]${RE}last [-*  ][ -* ]      "
}

@test "a failing silent command with --inline-sweep-stderr returns its exit status" {
    NO_OUTPUT='message: '
    run -1 invocationMessage --message "$NO_OUTPUT" --timespan 0 --inline-sweep-stderr false
    assert_output ''
}
