#!/usr/bin/env bats

load fixture
load inline

export S='sleep 0.01;'

@test "single-line output from the command is individually appended / error output rotates the spinner" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${SAVE_CURSOR_POSITION}stdout / "
}

@test "multi-line output from the command is individually appended / error output rotates the spinner" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "message: /-${SAVE_CURSOR_POSITION}stdout \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout again | "
}

@test "single-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "message: ${SAVE_CURSOR_POSITION}stdout /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and final sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "message: /-${SAVE_CURSOR_POSITION}stdout \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}stdout again |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --clear all --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${SAVE_CURSOR_POSITION}message: stdout /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${SAVE_CURSOR_POSITION}message: /-stdout \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stdout again |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "single-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --inline-spinner-stderr --clear all --success OK --command "$ECHO_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout" ]
    assert_sink "${SAVE_CURSOR_POSITION}message: stdout /${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "multi-line output from the command is individually appended / error output rotates the spinner and then cleared with sigil" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --clear all --success OK --command "$MIXED_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "stdout
stdout again" ]
    assert_sink "${SAVE_CURSOR_POSITION}message: /-stdout \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: stdout again |${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}"
}

@test "mixed longer output starting and ending with stdout spinning" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "message: ${SAVE_CURSOR_POSITION}foo /-\\|${RESTORE_CURSOR_POSITION}${ERASE_TO_END}second /-${RESTORE_CURSOR_POSITION}${ERASE_TO_END}third argument \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}immediate fourth |/-\\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}foo |/${RESTORE_CURSOR_POSITION}${ERASE_TO_END}last - "
}

@test "mixed longer output starting and ending with stderr spinning" {
    run invocationMessage --message 'message: ' --timespan 0 --inline-spinner-stderr --command "
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
    assert_sink "message: /-\\|${SAVE_CURSOR_POSITION}foo /-\\|${RESTORE_CURSOR_POSITION}${ERASE_TO_END}second /-${RESTORE_CURSOR_POSITION}${ERASE_TO_END}third argument \\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}immediate fourth |/-\\${RESTORE_CURSOR_POSITION}${ERASE_TO_END}foo |/${RESTORE_CURSOR_POSITION}${ERASE_TO_END}last -\\ "
}
