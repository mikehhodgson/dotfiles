# Waybar migration

The bar settings live in `.config/omarchy/shell.json`. Appearance overrides
live in `.config/omarchy/shell.toml`. The current 16 px text size is retained;
the shell uses Nasalization through a Quickshell-specific rule in
`.config/fontconfig/fonts.conf`, and the bar keeps the old 30 px height.
Terminals and other applications retain their existing font selection.

Menu and workspaces are on the left. The center follows Quattro's arrangement:
state indicators, clock, weather and updates, with the clock anchored centrally.
Tray, GnuCash, Bluetooth, network, audio, CPU, memory and battery are on the
right. The tray was
moved to the left edge of the right group after migration. The
existing pinned KeePassXC tray setting is retained.

The active bar is Quattro's stock `omarchy.bar`; there is no full-bar clone.
Small personal widgets keep changes out of the packaged Omarchy code:

- `mike.cpu`, `mike.memory`, and `mike.gnucash`: polled status labels using
  the configured shell font size, with green text for GnuCash. Their
  commands and click actions are configured inline in `shell.json`.
- `mike.workspaces`: persistent workspaces 1–5, numeric labels (10 becomes
  0), SP for special workspaces, red focused workspace and dim empty labels.
- `mike.clock`: Perth/UTC switching confined to the displayed clock;
  left click switches zones, right click switches between the two date
  formats, middle click opens the year calendar. Scrolling the clock opens
  the calendar and browses years. The calendar has Sunday-first weeks,
  ISO week numbers and the old Waybar calendar colors. Set `calendarMode`
  to `month` in its layout entry to use the original Omarchy month panel.
- `mike.power`: time estimate, charge/discharge direction, watts, percentage
  and battery icon on the bar. Hover opens the native power card after 300 ms
  without taking keyboard focus; it closes 250 ms after leaving the button
  and card. Left click keeps it open for interaction; right click has no action.
  The old plain-text tooltip is removed. `PowerPopup.qml`
  copies the installed popup component with a non-modal hover mode.
  Two fixed widths prevent telemetry updates from shifting neighbouring
  widgets: compact for percentage/icon, expanded for time/power/percentage/icon.
  `compactWidthText` and `expandedWidthText` in the power layout entry set the
  reference strings measured in the current font. Width changes only with
  the display mode or font settings.
  Labels are right-aligned. Detailed time uses `T-H:MM` with one hour digit;
  estimates of 10 hours or more display `T-9:99`. Watts use one decimal below
  10 W and whole numbers above, capped at 99 W on the bar. Missing readings
  display dashes. The popup retains the original, uncapped telemetry.
- `mike.tray`: `showAll: true` keeps every active tray icon visible without
  an expander, including newly started apps. The native filtering of passive
  icons and apps already represented by dedicated bar widgets is retained.
  Set `showAll` to `false` to return to the pinned/hidden drawer behaviour.
- `mike.indicators`: the group left of the clock follows `[bar] active`
  (NASA red), matching the active workspace. Inactive icons keep their native
  dimmed opacity.

The CPU and memory command widgets read `/proc` through `bar/scripts/status.py`.
CPU left click opens btop and right click opens Alacritty. The GnuCash indicator
uses the same finance-directory lock-file check as Waybar. Its click action and
SUPER+SHIFT+C share the Stow-managed `launch-or-focus-gnucash` script. When
the accounting lock file exists, it tries Omarchy's address-based focus helper,
then Sway and i3 focus commands. Otherwise it launches GnuCash via `uwsm-app`.
GnuCash uses the native `BarIconButton` sizing and slot width, retaining its
green warning colour and taking no space when inactive.

CPU and memory sit immediately before power and reserve fixed widths measured
from their `widthText` settings, including padding. Readings do not change the
reserved width; it follows font changes. Both readings are right-aligned
inside their reserved widths, with reduced padding. CPU reserves space for
`100%` plus its icon; memory uses one decimal below 10 GiB and whole numbers
from 10 GiB upward. Its width sample is `9.9G/31G` for this machine's 31 GiB total.
Update memory's `widthText` if the RAM total changes.

Menu, weather, Bluetooth, network, audio, update and state indicators use
Quattro's existing widgets. Weather has the native forecast panel and a full
notification on right click. The inactive USB eject and tray-expander definitions
were not enabled: neither appeared in the old Waybar module lists. The disabled
battery blinking CSS remains disabled.

The workspace, clock, power and tray clones were copied from the installed
Quattro sources. Their `omarchy.clonedFrom`
metadata preserves built-in IPC routing. Review upstream changes when updating
Omarchy; personal clones are not automatically replaced by package updates.

The old Waybar files remain available as the migration reference.

## Lock screen

`mike.lock` replaces `omarchy.lock` to recover the styling from
`hypr/.config/hypr/hyprlock.conf`, deleted in commit `94709fe` on 2026-09-30.
The packaged lock view hardcodes geometry and blur, so a plugin clone is
needed for these changes. Its `Service.qml` is an unmodified copy of the
installed authentication service; only `LockView.qml` is customised.

- Current wallpaper without blur; no added animations.
- Centred 650 × 100 password field, capped to fit small displays.
- 1 px border, 10 px corners, soft 4 px shadow (Qt approximation).
- Nasalization via the shared shell font rule; uppercase placeholder and
  `AUTHENTICATION FAILED (attempts)` message without italics.
- Rounded password dots with half-dot spacing; the field stays visible when empty.
- Theme-derived field/text/border colours; red failure text and border configured
  in the user `shell.toml` under `[lock]`.

The former Hyprlock fingerprint-disable directive was not carried into
authentication configuration: this migration changes styling. Native PAM,
fingerprint detection and password handling remain in the copied service.
Qt's circular password glyphs and shadow do not exactly reproduce Hyprlock's
dot corner-radius and shadow-boost controls.

Use `omarchy-shell lock preview` and `omarchy-shell lock hidePreview` to inspect
the appearance without locking. Lock plugin code changes require a shell
restart because the authentication service stays loaded. Review the clone
against packaged lock updates so authentication fixes remain current.
