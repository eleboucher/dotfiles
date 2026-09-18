#!/bin/sh
# Publish the session environment and mark the compositor ready.
#
# Under uwsm, `uwsm finalize` exports the variables AND sends the readiness
# notification that completes wayland-wm@sway.desktop.service. Without that
# notification the unit times out after 30s and its OnFailure= tears the whole
# session down (i.e. it logs you straight back out).
#
# Outside uwsm (the plain sway.desktop session) `uwsm finalize` exits 1, so do
# the same job by hand: import the variables, then start sway-session.target,
# which pulls in graphical-session.target via BindsTo. graphical-session.target
# sets RefuseManualStart, so it cannot be started directly - anything bound to
# it (gammastep.service, and any other user unit) otherwise never starts here.
#
# This lives in a script rather than inline in execs.conf because sway's config
# parser treats `;` as a command separator even inside shell parentheses, so a
# multi-command shell line there gets split and half of it fails to parse.

VARS="WAYLAND_DISPLAY SWAYSOCK DISPLAY XDG_CURRENT_DESKTOP"

if uwsm finalize SWAYSOCK 2>/dev/null; then
    exit 0
fi

systemctl --user import-environment $VARS
dbus-update-activation-environment --systemd $VARS
systemctl --user start sway-session.target
