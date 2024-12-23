#!/usr/bin/env bats

load command

@test "a custom marker can be configured and leaves the original marker unchanged" {
    export INVOCATIONNOTIFICATION_MESSAGE_MARKER=@@
    INVOCATIONNOTIFICATION_COMMANDLINE="${INVOCATIONNOTIFICATION_COMMANDLINE//\{\}/$INVOCATIONNOTIFICATION_MESSAGE_MARKER \{\}}"
    run -0 invocationNotification --to command --message 'message: ' echo executed
    assert_output 'executed'
    assert_runs <<'EOF'
[message: ]
[{}]
EOF
}
