#!/usr/bin/env bats

load fixture

@test "error when no command is defined" {
    run -2 progressNotification --to command <<<'executed'
    assert_output 'ERROR: Command notification must define PROGRESSNOTIFICATION_COMMANDLINE.'
}

@test "the error from a pre-command failure is returned" {
    export PROGRESSNOTIFICATION_COMMANDLINE="true"
    export PROGRESSNOTIFICATION_PRE_COMMANDLINE="exit 42"
    run -42 progressNotification --to command <<<'executed'
}

@test "the error from a post-command failure is returned" {
    export PROGRESSNOTIFICATION_COMMANDLINE="true"
    export PROGRESSNOTIFICATION_POST_COMMANDLINE="exit 43"
    run -43 progressNotification --to command <<<'executed'
}
