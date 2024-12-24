#!/usr/bin/env bats

load fixture

@test "single-line error from the command is appended to the message after the command concludes" {
    run -0 invocationMessage --message 'message: ' --command "$SINGLE_LINE_COMMAND"
    assert_output 'message: from command'
}

@test "multi-line error from the command is appended to the message after a newline when stderr is to terminal" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -0 invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"
    assert_output - <<EOF
message:${SP}
from command
more from command
EOF
}

@test "multi-line error from the command is directly appended to the message when stderr is redirected" {
    run -0 invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"
    assert_output - <<'EOF'
message: from command
more from command
EOF
}

@test "single-line error from the command is appended to the message and sigil separated by a semicolon when stderr is to terminal" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -0 invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output 'message: OK; from command'
}

@test "single-line error from the command is directly appended to the message and sigil when stderr is redirected" {
    run -0 invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output 'message: OKfrom command'
}

@test "multi-line error from the command is appended to the message and sigil when stderr is to terminal" {
    INVOCATIONMESSAGE_STDERR_TO_TERM=t run -0 invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    assert_output - <<'EOF'
message: OK
from command
more from command
EOF
}

@test "multi-line error from the command is appended to the message and sigil when stderr is redirected" {
    run -0 invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"
    assert_output - <<'EOF'
message: OKfrom command
more from command
EOF
}

@test "single-line error from the command is printed after the cleared message after the command concludes" {
    run -0 invocationMessage --message 'message: ' --clear all --command "$SINGLE_LINE_COMMAND"
    assert_output "${S}message: ${RE}from command"
}

@test "multi-line error from the command is printed after the cleared message after the command concludes" {
    run -0 invocationMessage --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"
    assert_output - <<EOF
${S}message: ${RE}from command
more from command
EOF
}

@test "single-line error from the command is printed after the cleared message and sigil after the command concludes" {
    run -0 invocationMessage --message 'message: ' --clear all --success OK --command "$SINGLE_LINE_COMMAND"
    assert_output "${S}message: OK${RE}from command"
}

@test "multi-line error from the command is printed after the cleared message and sigil after the command concludes" {
    run -0 invocationMessage --message 'message: ' --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output - <<EOF
${S}message: OK${RE}from command
more from command
EOF
}

@test "a failing silent command returns its exit status" {
    NO_OUTPUT="message: "
    run -1 invocationMessage --message "$NO_OUTPUT" false
    assert_output "$NO_OUTPUT"
}
