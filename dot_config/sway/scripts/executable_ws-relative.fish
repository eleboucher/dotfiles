#!/usr/bin/env fish

# Step to the workspace <delta> away by number, creating it if it does not exist
# yet - Hyprland's `workspace -1` / `workspace +1`. Sway's own `workspace
# prev/next` only cycles workspaces that already exist, so it stays bound
# separately on $mod+Shift+z/x.

if test (count $argv) -ne 1
    echo 'Usage: ws-relative.fish <delta>' >&2
    exit 1
end

set -l current (swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')

if test -z "$current" -o "$current" = null
    exit 0
end

swaymsg workspace number (math "max(1, $current + $argv[1])")
