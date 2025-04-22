#!/bin/bash

decontrol()
{
    typeset -a decontrollingArgs=()
    local varName; for varName in $(compgen -v | grep '^[A-Z]$')
    do
	decontrollingArgs+=(--from-to "${!varName}" "\${${varName}}")
    done
    eval "${decontrollingArgs:+literalGsub \"\${decontrollingArgs[@]\}\" |}" trcontrols
}

assert_control_output()
{
    if [ "${1?}" = - ]; then
	decontrol | output="$(printf '%s\n' "$output" | decontrol)" assert_output -
    else
	output="$(printf '%s\n' "$output" | decontrol)" assert_output "$(printf '%s\n' "$1" | decontrol)"
    fi
}

dump_output()
{
    printf 'actual: %s\n' "$output" | decontrol | prefix \# >&3
    return 1
}
