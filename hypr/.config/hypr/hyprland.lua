-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Window behavior migrated from the legacy monitors.conf and input.conf.
o.window("osgViewer", { immediate = true })

o.window("ecwolf", {
  content = "game",
  immediate = true,
  fullscreen = true,
})

o.window("steam_app_220200", {
  content = "game",
  immediate = true,
  fullscreen = true,
})

o.window("Gitk", { maximize = true })

o.window("xdg-desktop-portal-gtk", {
  focus_on_activate = true,
  float = true,
})

o.window("gnucash", { no_screen_share = true })
