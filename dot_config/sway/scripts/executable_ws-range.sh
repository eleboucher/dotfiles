#!/bin/sh
# Print the workspace numbers pinned to output $1 (a connector name, e.g. DP-1),
# in order.
#
# Parsed straight out of the `workspace N output ...` lines in the main config
# so the mapping lives in exactly one place - previously it was hardcoded
# separately in ws-wheel.sh and move-to-empty.fish, which silently did nothing
# on any output not named there.
#
# Those lines pin by `set $left/$right "make model serial"` rather than by
# connector name (two identical monitors - see the comment in the main config),
# so resolve the variable first: ask sway for $1's own make/model/serial and
# treat any `set` whose value matches it as naming this output. A literal
# connector name in a `workspace ... output` line still matches directly, so
# either style works.

[ -n "$1" ] || exit 1

ident=$(swaymsg -t get_outputs \
    | jq -r --arg n "$1" '.[] | select(.name == $n) | "\(.make) \(.model) \(.serial)"')

awk -v name="$1" -v ident="$ident" '
    $1 == "set" && $2 ~ /^\$/ {
        value = $0
        sub(/^[[:space:]]*set[[:space:]]+\$[^[:space:]]+[[:space:]]+/, "", value)
        gsub(/"/, "", value)
        if (ident != "" && value == ident) alias[$2] = 1
        next
    }
    $1 == "workspace" && $3 == "output" {
        if ($4 == name || $4 in alias) print $2
    }
' "${XDG_CONFIG_HOME:-$HOME/.config}/sway/config"
