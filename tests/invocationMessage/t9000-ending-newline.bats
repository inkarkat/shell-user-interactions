#!/usr/bin/env bats

load fixture

runneeWrapper()
{
    "$@"
    local status=$?
    printf '$'
    return $status
}
runWithFullOutput()
{
    run runneeWrapper "$@"
    output="${output%\$}"
}

@test "true prints the message" {
    runWithFullOutput invocationMessage --message 'message: ' true

    [ $status -eq 0 ]
    [ "$output" = "message: 
" ]
}

@test "true with clear prints and then erases the message" {
    runWithFullOutput invocationMessage --message 'message: ' --clear all true

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "true appends the passed success sigil" {
    runWithFullOutput invocationMessage --message 'message: ' --success OK --fail FAILED true

    [ $status -eq 0 ]
    [ "$output" = "message: OK
" ]
}

@test "true with clear appends the passed success sigil, waits, and erases" {
    runWithFullOutput invocationMessage --message 'message: ' --clear all --success OK --fail FAILED true

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "single-line error from the command is appended to the message after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: from command
" ]
}

@test "multi-line error from the command is appended to the message after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: 
from command
more from command
" ]
}

@test "single-line error from the command is appended to the message and sigil after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OK; from command
" ]
}

@test "multi-line error from the command is appended to the message and sigil after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: OK
from command
more from command
" ]
}

@test "single-line error from the command is printed after the cleared message after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command
" ]
}

@test "multi-line error from the command is printed after the cleared message after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command
more from command
" ]
}

@test "single-line error from the command is printed after the cleared message and sigil after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command
" ]
}

@test "multi-line error from the command is printed after the cleared message and sigil after the command concludes" {
    runWithFullOutput invocationMessage --message 'message: ' --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}from command
more from command
" ]
}

@test "single-line error from the command is individually appended to the message as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --inline-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command
" ]
}

@test "multi-line error from the command is individually appended to the message as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --inline-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}more from command
" ]
}

@test "single-line error from the command is individually appended to the message and sigil as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --inline-stderr --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK
" ]
}

@test "multi-line error from the command is individually appended to the message and sigil as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --inline-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: ${SAVE_CURSOR_POSITION}from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}more from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK
" ]
}

@test "multi-line error from the command is individually appended and then cleared" {
    runWithFullOutput invocationMessage --message 'message: ' --inline-stderr --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: more from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command is individually appended and then cleared with sigil" {
    runWithFullOutput invocationMessage --message 'message: ' --inline-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}message: more from command${RESTORE_CURSOR_POSITION}${ERASE_TO_END}OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "single-line error from the command powers a spinner after the message as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: / 
" ]
}

@test "multi-line error from the command powers a spinner after the message as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /- 
" ]
}

@test "single-line error from the command powers a spinner after the message and sigil as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /OK
" ]
}

@test "multi-line error from the command powers a spinner after the message and sigil as the command runs" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "message: /-OK
" ]
}

@test "single-line error from the command powers a spinner and then cleared" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --clear all --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: / ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command powers a spinner and then cleared" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --clear all --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: /- ${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "single-line error from the command powers a spinner and then cleared with sigil" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --clear all --success OK --command "$SINGLE_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: /OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error from the command powers a spinner and then cleared with sigil" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --clear all --success OK --command "$MULTI_LINE_COMMAND"

    [ $status -eq 0 ]
    [ "$output" = "${SAVE_CURSOR_POSITION}message: /-OK${RESTORE_CURSOR_POSITION}${ERASE_TO_END}" ]
}

@test "multi-line error that contains the statusline marker does not rotate the spinner" {
    runWithFullOutput invocationMessage --message 'message: ' --spinner-stderr --command '{ echo first; echo \#-\#666; echo last; } >&2'

    [ $status -eq 0 ]
    [ "$output" = "message: /- 
" ]
}
