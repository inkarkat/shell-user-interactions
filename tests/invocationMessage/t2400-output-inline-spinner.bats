#!/usr/bin/env bats

load fixture
load inline

@test "single-line output from the command is individually appended / error output rotates the spinner" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${S}stdout / "
}

@test "multi-line output from the command is individually appended / error output rotates the spinner" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "message: /-${S}stdout \\${RE}stdout again | "
}

@test "multi-line output in different order from the command is individually appended / error output rotates the spinner" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "message: ${S}stdout /-${RE}stdout again \\| "
}

@test "single-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${S}stdout /${RE}OK"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "message: /-${S}stdout \\${RE}stdout again |${RE}OK"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: stdout /${RE}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${S}message: /-stdout \\${RE}message: stdout again |${RE}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${S}message: stdout /${RE}message: OK${RE}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --success OK --command "$BOTH_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
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

    [ $status -eq 0 ]
    [ "$output" = "foo
foo
foo
foo
bar
bar" ]
    assert_sink "message: ${S}foo /-\\|/${RE}bar -\\ "
}

@test "mixed longer output starting and ending with stdout spinning" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "message: ${S}foo /-\\|${RE}second /-${RE}third argument \\${RE}immediate fourth |/-\\${RE}foo |/${RE}last - "
}

@test "mixed longer output starting and ending with stderr spinning" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "message: /-\\|${S}foo /-\\|${RE}second /-${RE}third argument \\${RE}immediate fourth |/-\\${RE}foo |/${RE}last -\\ "
}
