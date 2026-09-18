#!/bin/sh
# Debounced, monitor-local workspace stepping for the mouse wheel.
# Hyprland bound the wheel to `m-1`/`m+1` - relative *within the current
# monitor* - so this stays on the focused output. ($mod+z/x keeps the
# absolute numeric stepping of Hyprland's `-1`/`+1`, which may cross
# monitors; that difference is deliberate.)
#
# Debounce: sway fires a mouse bind once per RAW axis event, and the G502 X's
# hi-res wheel emits several events per physical detent, including tiny
# backward ticks mid-notch (seatop_default.c matches on the delta sign
# alone). Measured 9 bind executions for one physical click. The lock window
# collapses a burst into one switch and keeps the direction that won the
# lock. No staleness guard is needed: the lock lives in XDG_RUNTIME_DIR,
# which is tmpfs and cleared when the session ends.
#
# Steps by workspace *number* within the output's own range rather than using
# next/prev_on_output, which is a no-op at the edge of the workspaces that
# currently exist and so made the wheel feel dead in one direction. Stepping
# by number reaches a not-yet-created workspace inside the range, and clamps
# at the range ends. The range comes from ws-range.sh, i.e. from the
# `workspace N output ...` pinning in the main config.

dir=$1
case $dir in +1|-1) ;; *) exit 1 ;; esac

lock=${XDG_RUNTIME_DIR:?}/sway-ws-wheel.lock
window=0.12

mkdir "$lock" 2>/dev/null || exit 0
( sleep "$window"; rmdir "$lock" 2>/dev/null ) &

output=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
[ -n "$output" ] && [ "$output" != null ] || exit 0

range=$(dirname "$0")/ws-range.sh
range=$("$range" "$output")
[ -n "$range" ] || exit 0

current=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')
case $current in ''|null) exit 0 ;; esac

# Walk the output's range to find where we are, then step one slot and clamp.
prev= target= take=
for ws in $range; do
    if [ -n "$take" ]; then target=$ws; take=; fi
    if [ "$ws" = "$current" ]; then
        if [ "$dir" = -1 ]; then
            target=${prev:-$current}
        else
            take=1
        fi
    fi
    prev=$ws
done

# Current workspace isn't in this output's range (unpinned workspace on this
# output): jump to the near end of the range instead of doing nothing.
if [ -z "$target" ]; then
    if [ "$dir" = -1 ]; then
        target=$(echo "$range" | head -n 1)
    else
        target=$(echo "$range" | tail -n 1)
    fi
fi

[ "$target" = "$current" ] && exit 0
exec swaymsg "workspace number $target" >/dev/null
