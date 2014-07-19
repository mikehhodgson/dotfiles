-- auto reload config
pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
--hydra.alert("Hydra config loaded", 1.5)

function bindkeys()
   local mash = {"cmd", "alt"}
   local mashmash = {"cmd", "ctrl", "alt"}

   hotkey.bind(mash, "r", hydra.reload)
   hotkey.bind(mashmash, "R", repl.open)
   hotkey.bind(mashmash, "f", maximise)
   hotkey.bind(mashmash, "c", center)
   hotkey.bind(mash, "left", left)
   hotkey.bind(mash, "right", right)
   hotkey.bind(mash, "up", top)
   hotkey.bind(mash, "down", bottom)
   hotkey.bind(mashmash, "left", bottomleft)
   hotkey.bind(mashmash, "right", topright)
   hotkey.bind(mashmash, "up", topleft)
   hotkey.bind(mashmash, "down", bottomright)
end

function maximise()
  local win = window.focusedwindow()
  if not win then return end
  local frame = win:screen():frame_without_dock_or_menu()
  win:setframe(frame)
end

function center()
  local win = window.focusedwindow()
  if not win then return end
  local screen = win:screen():frame_without_dock_or_menu()
  local f = win:frame()
  f.x = screen.w / 2 - (f.w / 2)
  f.y = screen.h / 2 - (f.h / 2)
  win:setframe(f)
end

-- if no argument, pushes focused window left
-- if pass a screen frame, make it left and return it
function left(...)
   local frame = select(1, ...)
   if frame then
      frame.w = frame.w / 2
      return frame
   else
      local win = window.focusedwindow()
      if not win then return end
      frame = win:screen():frame_without_dock_or_menu()
      frame = left(frame)
      win:setframe(frame)
   end
end

-- if no argument, pushes focused window right
-- if pass a screen frame, make it right and return it
function right(...)
   local frame = select(1, ...)
   if frame then
      frame.w = frame.w / 2
      frame.x = frame.w
      return frame
   else
      local win = window.focusedwindow()
      if not win then return end
      frame = win:screen():frame_without_dock_or_menu()
      frame = right(frame)
      win:setframe(frame)
   end
end

function top(...)
   local frame = select(1, ...)
   if frame then
      frame.h = frame.h / 2
      return frame
   else
      local win = window.focusedwindow()
      if not win then return end
      frame = win:screen():frame_without_dock_or_menu()
      frame = top(frame)
      win:setframe(frame)
   end
end

function bottom(...)
   local frame = select(1, ...)
   if frame then
      frame.h = frame.h / 2
      frame.y = frame.y + frame.h  -- account for menu bar
      return frame
   else
      local win = window.focusedwindow()
      if not win then return end
      frame = win:screen():frame_without_dock_or_menu()
      frame = bottom(frame)
      win:setframe(frame)
   end
end

function topleft()
  local win = window.focusedwindow()
  if not win then return end
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  win:setframe(newframe)
end

function bottomleft()
  local win = window.focusedwindow()
  if not win then return end
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  newframe.y = newframe.h + (win:screen():frame_including_dock_and_menu().h -
                                win:screen():frame_without_dock_or_menu().h)
  win:setframe(newframe)
end

function bottomright()
  local win = window.focusedwindow()
  if not win then return end
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  newframe.x = newframe.w
  newframe.y = newframe.h + (win:screen():frame_including_dock_and_menu().h -
                                win:screen():frame_without_dock_or_menu().h)
  win:setframe(newframe)
end

function topright()
  local win = window.focusedwindow()
  if not win then return end
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  newframe.x = newframe.w
  win:setframe(newframe)
end

-- show available updates
local function showupdate()
  os.execute('open https://github.com/sdegutis/Hydra/releases')
end

-- what to do when an update is checked
function updates.available(available)
  if available then
    notify.show("Hydra update available", "", "Click here to see the changelog and maybe even install it", "showupdate")
  else
    hydra.alert("No update available.")
  end
end

-- Uncomment this if you want Hydra to make sure it launches at login
autolaunch.set(true)

-- check for updates every week
timer.new(timer.weeks(1), checkforupdates):start()
notify.register("showupdate", showupdate)

-- if this is your first time running Hydra, you're launching it more than a week later, check now
local lastcheckedupdates = settings.get('lastcheckedupdates')
if lastcheckedupdates == nil or lastcheckedupdates <= os.time() - timer.days(7) then
  checkforupdates()
end

-- save the time when updates are checked
function checkforupdates()
  updates.check()
  settings.set('lastcheckedupdates', os.time())
end

-- show a helpful menu
menu.show(function()
    local updatetitles = {[true] = "Install Update", [false] = "Check for Update..."}
    local updatefns = {[true] = updates.install, [false] = checkforupdates}
    local hasupdate = (updates.newversion ~= nil)

    return {
      {title = "Reload Config", fn = hydra.reload},
      {title = "-"},
      {title = "About", fn = hydra.showabout},
      {title = updatetitles[hasupdate], fn = updatefns[hasupdate]},
      {title = "Quit Hydra", fn = os.exit},
    }
end)

bindkeys()
