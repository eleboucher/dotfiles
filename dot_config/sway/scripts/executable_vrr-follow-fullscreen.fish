#!/usr/bin/env fish

# Toggle adaptive_sync per output based on whether its *visible* workspace
# currently shows a fullscreen window - Hyprland's `vrr 2`. Sway's own
# `adaptive_sync` is a static per-output config value with no such mode
# (confirmed against swayfx 0.6 source), so this reproduces it by reacting
# to sway IPC events.
#
# Every sway workspace *node* itself always reports fullscreen_mode 1
# (a sway internal quirk, unrelated to its contents), so detection has to
# start from the workspace's children, not the workspace node itself.
#
# `swaymsg output` is only called when the desired state actually differs
# from the current one. Without this check, every window event anywhere in
# the session (e.g. a browser tab title changing) reconfigures both
# outputs unconditionally, which was visibly bouncing Noctalia's
# notification layer-surface (toast appearing/disappearing/reappearing).

function sync_outputs
    set -l tree (swaymsg -t get_tree)
    set -l current (swaymsg -t get_outputs | jq -c '.[] | {name, on: (.adaptive_sync_status == "enabled")}')

    for row in (swaymsg -t get_workspaces | jq -c '.[] | select(.visible) | {num, output}')
        set -l num (echo $row | jq '.num')
        set -l output (echo $row | jq -r '.output')
        set -l want_on (echo $tree | jq --argjson n "$num" '
            [.. | objects | select(.type? == "workspace" and .num == $n)][0]
            | [(.nodes[]?, .floating_nodes[]?) | .. | objects | select(.fullscreen_mode? == 1)]
            | length > 0')
        set -l is_on (echo $current | jq --arg o "$output" 'select(.name == $o) | .on')

        if test "$want_on" != "$is_on"
            if test "$want_on" = true
                swaymsg output $output adaptive_sync on >/dev/null
            else
                swaymsg output $output adaptive_sync off >/dev/null
            end
        end
    end
end

sync_outputs

swaymsg -t subscribe -m '["window", "workspace"]' | while read -l line
    sync_outputs
end
