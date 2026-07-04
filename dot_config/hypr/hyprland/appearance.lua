-- Appearance: colors, decoration, animations, layer rules

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 2,
        -- Static fallback; Noctalia overrides these via require("noctalia").apply_theme()
        -- in hyprland.lua (runs after this module) with live palette colors.
        col = {
            active_border   = "rgb(a8c8e0)",
            inactive_border = "rgb(101218)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 20,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = true, range = 20, color = "rgba(00000080)" },
        blur = { enabled = true, size = 8, passes = 1 },
    },
    animations = { enabled = true },
})

-- Animation curves and leaves
hl.curve("myBezier", { type = "bezier", points = { { 0.4, 0.0 }, { 0.2, 1.0 } } })
hl.animation({ leaf = "windows",    enabled = true, speed = 2.5, bezier = "myBezier", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 2.5, bezier = "myBezier" })
hl.animation({ leaf = "fade",       enabled = true, speed = 2.5, bezier = "myBezier" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.5, bezier = "myBezier", style = "slidefade 20%" })

-- Blur behind Noctalia surfaces
for _, ns in ipairs({
    "noctalia-bar-default",
    "noctalia-dock",
    "noctalia-attached-panel",
    "noctalia-centered-panel",
    "noctalia-floating-panel",
}) do
    hl.layer_rule({ blur = true, match = { namespace = ns } })
end
