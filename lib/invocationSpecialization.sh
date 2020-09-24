#!/bin/bash

printShortUsage()
{
    # Note: short followed by long option; if the user knows the short one, she can
    # skim the long one.
    printf 'Usage: %q %s\n' "$(basename "$1")" '[--or-passthrough] [-m|--message MESSAGE] [--success SIGIL] [--fail SIGIL] [--no-clear|-C|--clear success|failure|all] [-T|--initial-delay TIMESPAN[SUFFIX]] -c|--command COMMANDLINE [...]|[--] SIMPLECOMMAND'
}
printUsage()
{
    # This is the short help when launched with no or incorrect arguments.
    # It is printed to stderr to avoid accidental processing.
    printShortUsage "$1" >&2
    printf >&2 'Try %q --help for more information.\n' "$(basename "$1")"
}
plural()
{
    if [ "$1" = 1 ]; then
	printf %s "${2}${4}"
    else
	printf %s "${2}${3:-s}"
    fi
}
printLongUsage()
{
    # This is the long "man page" when launched with the help argument.
    # It is printed to stdout to allow paging with 'more'.
    echo "${INVOCATIONSPECIALIZATION_DESCRIPTION:?}"
    echo
    printShortUsage "$1"
    cat <<HELPTEXT
    --or-passthrough	When not connected to a terminal, omit MESSAGE,
			SIGIL(s), and any periodic updates. Basically, just
			execute COMMAND(s) without interfering in any way.
    --message|-m MESSAGE
			Text describing what COMMAND is doing for the user.
			If omitted, uses the name extracted from COMMAND, and
			automatically clears everything at the end (unless
			--(no-)clear overrides that).
    --success SIGIL	Append SIGIL after MESSAGE if COMMAND succeeds.
    --fail SIGIL	Append SIGIL after MESSAGE if COMMAND fails.
    --no-clear		Do not automatically clear the COMMAND name when no
			MESSAGE is passed.
    --clear|-C success	Clear the MESSAGE if COMMAND succeeds.
			If --success is also given, will wait for
			${INVOCATIONSPECIALIZATION_SUCCESS_DISPLAY_DELAY?} $(plural $INVOCATIONSPECIALIZATION_SUCCESS_DISPLAY_DELAY second).
    --clear|-C failure	Clear the MESSAGE if COMMAND fails, i.e. returns a
			non-zero exit status.
			If --fail is also given, will wait for
			${INVOCATIONSPECIALIZATION_FAIL_DISPLAY_DELAY?} $(plural $INVOCATIONSPECIALIZATION_FAIL_DISPLAY_DELAY second).
    --clear|-C all	Clear the MESSAGE (and the periodic updates) regardless
			of whether COMMAND succeeds or not. If no MESSAGE has
			been given, the periodic updates will be cleared
			automatically.
    --initial-delay|-T TIMESPAN[SUFFIX]
			Wait for TIMESPAN before printing the message or
			appending / spinning / sweeping based on a line, or
			printing the first total running time. By default, the
			message is printed immediately. If COMMAND finishes
			earlier, no message (and SIGIL) get printed at all.
    --command|-c CMD	Execute the passed command line. When this is a simple
			command, it can also be passed as such.
EXIT STATUS:
    0	Complete success.
    1	Failed to write to the terminal.
    2	Bad invocation, wrong or missing command-line arguments.
    *   any exit status from COMMAND(s)

Example:
HELPTEXT
    printf 'largeFiles=$(%q %s)\n' "$(basename "$1")" 'find / -size +100M'
}

hasClear=
isNoClear=
hasMessage=
typeset -a commands=()
typeset -a args=()
while [ $# -ne 0 ]
do
    case "$1" in
	--help|-h|-\?)	shift; printLongUsage "$0"; exit 0;;
	--no-clear)	shift; isNoClear=t;;
	--clear|-C)	args+=("$1" "$2"); shift; shift; hasClear=t;;
	--message|-m)	args+=("$1" "$2"); shift; shift; hasMessage=t;;
	--command|-c)	args+=("$1" "$2"); shift; commands+=(${commands:+;} "$1"); shift;;
	--or-passthrough)
			args+=("$1"); shift;;
	--success|--fail|--initial-delay|-T)
			args+=("$1" "$2"); shift; shift;;
	--)		args+=("$1"); shift; break;;
	-*)		{ echo "ERROR: Unknown option \"$1\"!"; echo; printShortUsage "$0"; } >&2; exit 2;;
	*)		break;;
    esac
done

typeset -a addedArgs=()
if [ ! "$hasMessage" ]; then
    commandName="$(commandName --no-interpreter --undefined "${commands[*]}$*" ${commands:+--eval} "${commands[@]}" "$@")"
    addedArgs+=(--message "${commandName}${commandName:+ }")
    [ ! "$isNoClear" ] && [ ! "$hasClear" ] && addedArgs+=(--clear all)
fi

INVOCATIONMESSAGE_SUCCESS_DISPLAY_DELAY="${INVOCATIONSPECIALIZATION_SUCCESS_DISPLAY_DELAY?}" \
INVOCATIONMESSAGE_FAIL_DISPLAY_DELAY="${INVOCATIONSPECIALIZATION_FAIL_DISPLAY_DELAY?}" \
    exec invocationMessage $INVOCATIONSPECIALIZATION_ARGUMENTS "${addedArgs[@]}" "${args[@]}" "$@"
