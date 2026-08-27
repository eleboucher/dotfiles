#!/usr/bin/env fish

# Move the focused window to the first empty workspace on the current output and
# follow it there - Hyprland's `movetoworkspace emptym`. The per-output ranges
# mirror the `workspace N output ...` pinning in ../config.

set -l output (swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
set -l range

switch $output
    case DP-1
        set range (seq 1 5)
    case DP-2
        set range (seq 6 10)
    case '*'
        exit 0
end

# Workspace numbers that currently hold at least one window.
set -l occupied (swaymsg -t get_tree | jq -r '
    [ recurse(.nodes[]?, .floating_nodes[]?)
      | select(.type == "workspace")
      | select([recurse(.nodes[]?, .floating_nodes[]?) | select(.type == "con")] | length > 0)
      | .num ] | unique | .[]')

for ws in $range
    if not contains -- $ws $occupied
        swaymsg move container to workspace number $ws, workspace number $ws
        exit 0
    end
end
