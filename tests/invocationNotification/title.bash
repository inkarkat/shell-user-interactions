#!/bin/bash

export INVOCATIONNOTIFICATION_SINK=/dev/stdout

case "$TERM" in
    screen*)
	readonly R=']2;['
	readonly N=']\'
	readonly C=']2;\'
	;;
    *)
	readonly R=']2;['
	readonly N=']'
	readonly C=']2;'
	;;
esac
