#!/bin/bash

seconds="${1:?}"; shift
soleSecondFormat="${1:-%ss}"; shift

weeks=$((seconds / 604800))
seconds=$((seconds - 604800 * weeks))
days=$((seconds / 86400))
seconds=$((seconds - 86400 * days))
hours=$((seconds / 3600))
seconds=$((seconds - 3600 * hours))
minutes=$((seconds / 60))
seconds=$((seconds - (60 * minutes)))

[ $weeks -gt 0 ] && renderedWeeks="${weeks}w "
[ $days -gt 0 ] && renderedDays="${days}d "
[ $weeks -gt 0 -o $days -gt 0 -o $hours -gt 0 ] && printf -v renderedHours '%02d:' "$hours"
[ $weeks -gt 0 -o $days -gt 0 -o $hours -gt 0 -o $minutes -gt 0 ] && printf -v renderedMinutes '%02d:' "$minutes"
[ $weeks -gt 0 -o $days -gt 0 -o $hours -gt 0 -o $minutes -gt 0 ] && printf -v renderedSeconds '%02d' "$seconds" || printf -v renderedSeconds "$soleSecondFormat" "$seconds"
printf '%s%s%s%s%s' "$renderedWeeks" "$renderedDays" "$renderedHours" "$renderedMinutes" "$renderedSeconds"
