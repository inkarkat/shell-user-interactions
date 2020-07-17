#!/bin/bash

export INVOCATIONNOTIFICATION_SINK=/dev/stdout

case "$TERM" in
    screen*)
	readonly R=']2;'
	readonly N='\'
	;;
    *)
	readonly R=']2;'
	readonly N=''
	;;
esac
readonly C="${R}${N}"
