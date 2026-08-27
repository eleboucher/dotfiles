#!/bin/sh
# Debounced workspace stepping for the mouse wheel.
#
# sway fires a mouse bind once per RAW axis event, and the G502 X's hi-res
# wheel emits several events per physical detent, including tiny backward
# ticks mid-notch (seatop_default.c matches on the delta sign alone). Without
# a lock one notch skips 2+ workspaces or bounces back to where it started.
# The lock window collapses a burst of events into one switch and keeps the
# direction that won the lock.
#
# Steps by *number* (like ws-relative.fish does for $mod+z/x) rather than
# next_on_output: at the edge of the existing workspaces on an output,
# next/prev_on_output is a no-op, which made the wheel feel dead in one
# direction. Numeric stepping creates the next workspace instead, and the
# 1-5/6-10 output pinning in the main config keeps us on the right monitor.

dir=$1
[ "$dir" = +1 ] || [ "$dir" = -1 ] || exit 1

lock=${XDG_RUNTIME_DIR:?}/sway-ws-wheel.lock
window=0.12

mkdir "$lock" 2>/dev/null || exit 0
( sleep "$window"; rmdir "$lock" 2>/dev/null ) &

current=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')
case $current in ''|null) exit 0 ;; esac

next=$(( current + dir ))
[ "$next" -lt 1 ] && next=1
exec swaymsg "workspace number $next"
