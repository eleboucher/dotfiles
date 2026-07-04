-- Keybinds. Shell actions go through Noctalia IPC (noctalia msg ...).


local noctalia = "noctalia msg"

-- ── Noctalia shell ──────────────────────────────────────────────────────────
hl.bind("SUPER + Super_L", hl.dsp.exec_cmd(noctalia .. " panel-toggle launcher"))
hl.bind("SUPER + B", hl.dsp.exec_cmd(noctalia .. " panel-toggle control-center"))
hl.bind("SUPER + V", hl.dsp.exec_cmd(noctalia .. " panel-toggle clipboard"))
hl.bind("SUPER + COMMA", hl.dsp.exec_cmd(noctalia .. " panel-toggle wallpaper"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd(noctalia .. " window-switcher"))
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd(noctalia .. " panel-toggle session"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(noctalia .. " settings-toggle"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(noctalia .. " screenshot-region"))
hl.bind("SUPER + ALT + B", hl.dsp.exec_cmd(noctalia .. " config-reload"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- ── Media / volume / brightness (Noctalia OSD) ──────────────────────────────
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctalia .. " media toggle"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctalia .. " media previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctalia .. " media next"))
hl.bind("XF86AudioMedia", hl.dsp.exec_cmd(noctalia .. " media toggle"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(noctalia .. " media stop"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctalia .. " volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctalia .. " volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctalia .. " volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctalia .. " brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctalia .. " brightness-down"))
hl.bind("XF86Calculator", hl.dsp.exec_cmd("notify-send \"Soon\""))

-- ── Screenshots ─────────────────────────────────────────────────────────────
hl.bind("ALT + SHIFT + 4", hl.dsp.exec_cmd(noctalia .. " screenshot-region"))
hl.bind("ALT + SHIFT + 5", hl.dsp.exec_cmd("bash -c 'mkdir -p ~/Pictures/Screenshots; f=~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png; grim \"$f\" && wl-copy < \"$f\"'"))

-- ── Apps ────────────────────────────────────────────────────────────────────
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("zeditor"))
hl.bind("SUPER + G", hl.dsp.exec_cmd("nautilus"))

-- ── Window actions ──────────────────────────────────────────────────────────
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.move({ workspace = "emptym" }))
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Focus
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + CTRL + k", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + CTRL + j", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + CTRL + z", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + CTRL + h", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + CTRL + x", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + CTRL + l", hl.dsp.focus({ direction = "right" }))

-- Move window
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- Resize window
hl.bind("SUPER + ALT + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind("SUPER + ALT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind("SUPER + ALT + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind("SUPER + ALT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind("SUPER + ALT + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind("SUPER + ALT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))
hl.bind("SUPER + ALT + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind("SUPER + ALT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))

-- ── Workspaces ──────────────────────────────────────────────────────────────
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + Z", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + X", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + Z", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + X", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "+1" }))

-- ── Special workspaces ──────────────────────────────────────────────────────
hl.bind("SUPER + SHIFT + V", hl.dsp.workspace.toggle_special(""))
hl.bind("SUPER + ALT + V", hl.dsp.window.move({ workspace = "special" }))
hl.bind("SUPER + D", hl.dsp.workspace.toggle_special("communication"))
hl.bind("SUPER + M", hl.dsp.workspace.toggle_special("music"))
hl.bind("SUPER + R", hl.dsp.workspace.toggle_special("todo"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.workspace.toggle_special("sysmon"))

-- ── Lid switch ──────────────────────────────────────────────────────────────
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd(noctalia .. " dpms-off"))
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd(noctalia .. " dpms-on"))
