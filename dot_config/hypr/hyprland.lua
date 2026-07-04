-- Hyprland config (Lua, 0.55+). Modules live in hyprland/*.lua.

-- Monitor layout (DP-1 left, DP-2 right)
hl.monitor({ output = "",     mode = "preferred", position = "auto",   scale = 1 })
hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-2", mode = "preferred", position = "2560x0", scale = 1 })

-- Workspaces pinned to monitors (1-5 on DP-1, 6-10 on DP-2)
for ws = 1, 5 do
    hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-1" })
end
for ws = 6, 10 do
    hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-2" })
end

-- Load the rest: env, input/cursor, misc, appearance, autostart, rules, keybinds
local dir = (os.getenv("HOME") or "") .. "/.config/hypr/hyprland/"
for _, mod in ipairs({ "env", "input", "misc", "appearance", "execs", "rules", "binds" }) do
    dofile(dir .. mod .. ".lua")
end

-- Noctalia theme (border/group colors). Noctalia generates ~/.config/hypr/noctalia.lua
-- and manages this call; pcall guards the window before that file exists.
pcall(function() require("noctalia").apply_theme() end)
