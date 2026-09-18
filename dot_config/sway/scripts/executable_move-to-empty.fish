#!/usr/bin/env fish

# Move the focused window to the first empty workspace on the current output and
# follow it there - Hyprland's `movetoworkspace emptym`.

set -l output (swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
if test -z "$output" -o "$output" = null
    exit 0
end

# Workspaces pinned to this output, read from the main config via ws-range.sh
# rather than hardcoded here, so a new or renamed monitor only needs changing
# in one place.
set -l scripts (status dirname)
set -l range ($scripts/ws-range.sh $output)
if test -z "$range"
    exit 0
end

# Workspace numbers that currently hold at least one window. Floating windows
# are type "floating_con", not "con", so both have to be counted - matching
# only "con" reports a workspace holding just a floating window as empty.
set -l occupied (swaymsg -t get_tree | jq -r '
    [ recurse(.nodes[]?, .floating_nodes[]?)
      | select(.type == "workspace")
      | select([recurse(.nodes[]?, .floating_nodes[]?)
                | select(.type == "con" or .type == "floating_con")] | length > 0)
      | .num ] | unique | .[]')

for ws in $range
    if not contains -- $ws $occupied
        swaymsg move container to workspace number $ws, workspace number $ws >/dev/null
        exit 0
    end
end
