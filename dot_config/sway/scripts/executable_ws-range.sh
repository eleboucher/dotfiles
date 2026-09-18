#!/bin/sh
# Print the workspace numbers pinned to output $1, in order.
#
# Parsed straight out of the `workspace N output <name>` lines in the main
# config so the mapping lives in exactly one place - previously it was
# hardcoded separately in ws-wheel.sh and move-to-empty.fish, which silently
# did nothing on any output not named there.

[ -n "$1" ] || exit 1

awk -v out="$1" '$1 == "workspace" && $3 == "output" && $4 == out { print $2 }' \
    "${XDG_CONFIG_HOME:-$HOME/.config}/sway/config"
