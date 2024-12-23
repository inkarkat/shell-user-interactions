#!/usr/bin/env bats

load command

@test "executes command on a single update" {
    run -0 progressNotification --to command <<<'executed'
    assert_output ''
    assert_runs <<'EOF'
[executed]
[]
EOF
}

@test "executes command on the first of three updates because of the default timespan" {
    run -0 progressNotification --to command <<<$'first\nsecond\nthird'
    assert_output ''
    assert_runs <<'EOF'
[first]
[]
EOF
}

@test "executes command on all three updates with zero timespan" {
    run -0 progressNotification --to command --timespan 0 <<<$'first\nsecond\nthird'
    assert_runs <<'EOF'
[first]
[second]
[third]
[]
EOF
}

@test "executes special clear command" {
    printf -v PROGRESSNOTIFICATION_CLEAR_COMMANDLINE 'printf \\{%%s\\}\\\\n {} >> %q' "$RUNS"
    export PROGRESSNOTIFICATION_CLEAR_COMMANDLINE
    run -0 progressNotification --to command --timespan 0 <<<$'first\nsecond\nthird'
    assert_runs <<'EOF'
[first]
[second]
[third]
{}
EOF
}
@test "executes no clear command" {
    export PROGRESSNOTIFICATION_CLEAR_COMMANDLINE=''
    run -0 progressNotification --to command --timespan 0 <<<$'first\nsecond\nthird'
    assert_runs <<'EOF'
[first]
[second]
[third]
EOF
}
