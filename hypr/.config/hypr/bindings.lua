-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Personal bindings migrated from bindings.conf.

-- Preserve the Nautilus environment and terminal working-directory behavior.
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", 'GDK_BACKEND=wayland GTK_USE_PORTAL=0 GSK_RENDERER=ngl uwsm-app -- nautilus --no-desktop --new-window "$(omarchy-cmd-terminal-cwd)"')

hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", 'uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"')

o.bind("SUPER + E", "File manager", 'GDK_BACKEND=wayland GTK_USE_PORTAL=0 GSK_RENDERER=ngl uwsm-app -- nautilus --no-desktop --new-window "$(omarchy-cmd-terminal-cwd)"')

-- The old config moved private browsing from SUPER+SHIFT+ALT+B to SUPER+SHIFT+P.
hl.unbind("SUPER + SHIFT + ALT + B")
hl.unbind("SUPER + SHIFT + P")
o.bind("SUPER + SHIFT + P", "Browser (private)", "omarchy-launch-browser --private")

-- Replace Omarchy web-app shortcuts with the existing local applications/actions.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "GnuCash", "~/.local/bin/launch-or-focus-gnucash")

hl.unbind("SUPER + SHIFT + E")
o.bind("SUPER + SHIFT + E", "Editor", "omarchy-launch-editor")

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

-- Replace the default workspace-layout shortcut with system lock; keep layout on Shift+Alt+L.
hl.unbind("SUPER + L")
o.bind("SUPER + L", "Lock", "omarchy system lock")

hl.unbind("SHIFT + ALT + L")
o.bind("SHIFT + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Scratchpad controls.
hl.unbind("SUPER + CTRL + S")
o.bind("SUPER + CTRL + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad" }))
o.bind("SUPER + SHIFT + ALT + S", "Move window silently to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

o.bind("CTRL + SHIFT + ESCAPE", "btop", "omarchy-launch-or-focus-tui btop")
