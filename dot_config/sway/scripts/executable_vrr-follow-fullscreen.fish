#!/usr/bin/env fish

# Toggle adaptive_sync per output based on whether its *visible* workspace
# currently shows a fullscreen window - Hyprland's `vrr 2`. Sway's own
# `adaptive_sync` is a static per-output config value with no such mode
# (confirmed against swayfx 0.6 source), so this reproduces it by reacting
# to sway's `window` IPC events. Unconditional VRR on ordinary desktop
# content is what was causing the flicker on the LG UltraGears.
#
# Every sway workspace *node* itself always reports fullscreen_mode 1
# (a sway internal quirk, unrelated to its contents), so detection has to
# start from the workspace's children, not the workspace node itself.

function sync_outputs
    set -l tree (swaymsg -t get_tree)

    for row in (swaymsg -t get_workspaces | jq -c '.[] | select(.visible) | {num, output}')
        set -l num (echo $row | jq '.num')
        set -l output (echo $row | jq -r '.output')
        set -l has_fullscreen (echo $tree | jq --argjson n "$num" '
            [.. | objects | select(.type? == "workspace" and .num == $n)][0]
            | [(.nodes[]?, .floating_nodes[]?) | .. | objects | select(.fullscreen_mode? == 1)]
            | length > 0')
        if test "$has_fullscreen" = true
            swaymsg output $output adaptive_sync on >/dev/null
        else
            swaymsg output $output adaptive_sync off >/dev/null
        end
    end
end

sync_outputs

swaymsg -t subscribe -m '["window"]' | while read -l line
    sync_outputs
end
