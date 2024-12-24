#!/usr/bin/env bats

load overlay
load inline-sink

@test "multi-line output from the command is individually appended / error output sweeps and final sigil" {
    run -0 invocationNotification --to overlay --message 'message: ' --timespan 0 --sweep-stderr-inline --success OK --command "$BOTH_COMMAND"
    assert_output - <<'EOF'
stdout
stdout again
EOF
    assert_sink "${R}message: ${N}${R}message: [*   ]${N}${R}message: [-*  ]${N}${R}message: [ -* ] stdout${N}${R}message: [  -*] stdout again${N}${R}message: OK${N}"
}
