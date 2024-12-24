#!/usr/bin/env bats

load inline
load inline-sink

@test "single-line output from the command is individually appended / error output rotates the spinner" {
    run -0 invocationMessage --message 'message: ' --inline-spinner-stderr --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "message: ${S}stdout / "
}

@test "multi-line output from the command is individually appended / error output rotates the spinner" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "message: /-${S}stdout \\${RE}stdout again | "
}

@test "multi-line output in different order from the command is individually appended / error output rotates the spinner" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$MIXED_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "message: ${S}stdout /-${RE}stdout again \\| "
}

@test "single-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run -0 invocationMessage --message 'message: ' --inline-spinner-stderr --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "message: ${S}stdout /${RE}OK"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "message: /-${S}stdout \\${RE}stdout again |${RE}OK"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run -0 invocationMessage --message 'message: ' --inline-spinner-stderr --clear all --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${S}message: stdout /${RE}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${S}message: /-stdout \\${RE}message: stdout again |${RE}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run -0 invocationMessage --message 'message: ' --inline-spinner-stderr --clear all --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${S}message: stdout /${RE}message: OK${RE}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${S}message: /-stdout \\${RE}message: stdout again |${RE}message: OK${RE}"
}

@test "identical output lines still rotate the spinner" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
${MS}echo foo;
${MS}echo foo;
${MS}echo foo;
${MS}echo foo;
${MS}echo >&2 x;
${MS}echo bar;
${MS}echo bar;
"

    assert_success
    assert_output - <<'EOF'
foo
foo
foo
foo
bar
bar
EOF
    assert_sink "message: ${S}foo /-\\|/${RE}bar -\\ "
}

@test "mixed longer output starting and ending with stdout spinning" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "message: ${S}foo /-\\|${RE}second /-${RE}third argument \\${RE}immediate fourth |/-\\${RE}foo |/${RE}last - "
}

@test "mixed longer output starting and ending with stderr spinning" {
    run -0 invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "message: /-\\|${S}foo /-\\|${RE}second /-${RE}third argument \\${RE}immediate fourth |/-\\${RE}foo |/${RE}last -\\ "
}
