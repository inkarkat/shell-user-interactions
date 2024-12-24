#!/usr/bin/env bats

load command

@test "echo launches command with the message" {
    run -0 invocationNotification --to command --message 'message: ' echo executed
    assert_output 'executed'
    assert_runs '[message: ]'
}

@test "printf with clear launches command and then launches command with empty argument" {
    run -0 invocationNotification --to command --message 'message: ' --clear all printf executed
    assert_output 'executed'
    assert_runs <<'EOF'
[message: ]
[]
EOF
}

@test "echo with clear launches command and then launches command with empty argument" {
    run -0 invocationNotification --to command --message 'message: ' --clear all echo executed
    assert_output 'executed'
    assert_runs <<'EOF'
[message: ]
[]
EOF
}

@test "a failing command with clear launches command, then again with appended fail sigil, then with empty argument" {
    run -1 invocationNotification --to command --message 'message: ' --clear all --success OK --fail FAILED false
    assert_output ''
    assert_runs <<'EOF'
[message: ]
[message: FAILED]
[]
EOF
}

@test "multi-line error from the command is individually passed to command and finally message with sigil as the command runs" {
    run -0 invocationNotification --to command --message 'message: ' --timespan 0 --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"
    assert_output ''
    assert_runs <<'EOF'
[message: ]
[message: from command]
[message: more from command]
[message: OK]
EOF
}

@test "multi-line error from the command passes message and spinner, then sigil, then empty argument to command" {
    run -0 invocationNotification --to command --message 'message: ' --timespan 0 --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"
    assert_output ''
    assert_runs <<'EOF'
[message: ]
[message: /]
[message: -]
[message: OK]
[]
EOF
}
