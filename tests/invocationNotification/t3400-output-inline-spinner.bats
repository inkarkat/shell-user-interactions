#!/usr/bin/env bats

load overlay
load inline-sink

@test "single-line output from the command is individually appended / error output rotates the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-spinner-stderr --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${R}message: stdout${N}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: stdout \\${N}${R}message: stdout again |${N}${R}message: stdout again${N}"
}

@test "multi-line output in different order from the command is individually appended / error output rotates the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$MIXED_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${R}message: stdout -${N}${R}message: stdout again \\${N}${R}message: stdout again |${N}${R}message: stdout again${N}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-spinner-stderr --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${R}message: OK${N}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and ignores a fail sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-spinner-stderr --fail FAIL --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${R}message: stdout${N}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: stdout \\${N}${R}message: stdout again |${N}${R}message: OK${N}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-spinner-stderr --clear all --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${C}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: stdout \\${N}${R}message: stdout again |${N}${C}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-spinner-stderr --clear all --success OK --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${R}message: OK${N}${C}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and ignores a fail clear" {
    run -0 invocationNotification --to overlay --message 'message: ' --inline-spinner-stderr --clear failure --command "$ECHO_COMMAND"
    assert_output 'stdout'
    assert_sink "${R}message: ${N}${R}message: stdout /${N}${R}message: stdout${N}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: stdout \\${N}${R}message: stdout again |${N}${R}message: OK${N}${C}"
}


@test "empty line output from the command also rotates the spinner" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$WITH_EMPTY_COMMAND"
    assert_output - <<'EOF'
foo
bar

bar
EOF
    assert_sink "${R}message: ${N}${R}message: foo /${N}${R}message: bar -${N}${R}message: \\${N}${R}message: bar |${N}${R}message: bar${N}"
}
@test "identical output lines still rotate the spinner" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
${S}echo foo;
${S}echo foo;
${S}echo foo;
${S}echo foo;
${S}echo >&2 x;
${S}echo bar;
${S}echo bar;
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
    assert_sink "${R}message: ${N}${R}message: foo /${N}${R}message: foo -${N}${R}message: foo \\${N}${R}message: foo |${N}${R}message: foo /${N}${R}message: bar -${N}${R}message: bar \\${N}${R}message: bar${N}"
}

@test "mixed longer output starting and ending with stdout spinning" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "${R}message: ${N}${R}message: foo /${N}${R}message: foo -${N}${R}message: foo \\${N}${R}message: foo |${N}${R}message: second /${N}${R}message: second -${N}${R}message: third argument \\${N}${R}message: immediate fourth |${N}${R}message: immediate fourth /${N}${R}message: immediate fourth -${N}${R}message: immediate fourth \\${N}${R}message: foo |${N}${R}message: foo /${N}${R}message: last -${N}${R}message: last${N}"
}

@test "mixed longer output starting and ending with stderr spinning" {
    run invocationNotification --to overlay --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "${R}message: ${N}${R}message: /${N}${R}message: -${N}${R}message: \\${N}${R}message: |${N}${R}message: foo /${N}${R}message: foo -${N}${R}message: foo \\${N}${R}message: foo |${N}${R}message: second /${N}${R}message: second -${N}${R}message: third argument \\${N}${R}message: immediate fourth |${N}${R}message: immediate fourth /${N}${R}message: immediate fourth -${N}${R}message: immediate fourth \\${N}${R}message: foo |${N}${R}message: foo /${N}${R}message: last -${N}${R}message: last \\${N}${R}message: last${N}"
}

@test "a failing silent command with --inline-spinner-stderr returns its exit status" {
    run -1 invocationNotification --to overlay --message "message: " --inline-spinner-stderr false
}
