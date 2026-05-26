#!/bin/bash

load fixture

fakeTimestamps()
{
    let epoch=1595604200
    isHalf=
    while read -r _
    do
	printf '%d.%09d\n' $epoch ${isHalf:+500000000}
	if [ "$isHalf" ]; then
	    let epoch+=1
	    isHalf=
	else
	    isHalf=t
	fi
    done
}
export -f fakeTimestamps
export DATE=fakeTimestamps
