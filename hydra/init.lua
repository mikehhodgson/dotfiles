-- auto reload config
pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
--hydra.alert("Hydra config loaded", 1.5)

mash = {"cmd", "alt"}
mashmash = {"cmd", "ctrl", "alt"}

hotkey.bind(mash, "r", hydra.reload)
hotkey.bind(mashmash, "R", repl.open)
hotkey.bind(mashmash, "f", movewindow_maximise)
hotkey.bind(mashmash, "c", movewindow_center)
hotkey.bind(mash, "left", movewindow_lefthalf)
hotkey.bind(mash, "right", movewindow_righthalf)
hotkey.bind(mash, "up", movewindow_tophalf)
hotkey.bind(mash, "down", movewindow_bottomhalf)
hotkey.bind(mashmash, "left", movewindow_bottomleft)
hotkey.bind(mashmash, "right", movewindow_topright)
hotkey.bind(mashmash, "up", movewindow_topleft)
hotkey.bind(mashmash, "down", movewindow_bottomright)

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

function movewindow_maximise()
  local win = window.focusedwindow()
  local frame = win:screen():frame_without_dock_or_menu()
  win:setframe(frame)
end

function movewindow_center()
  local win = window.focusedwindow()
  local screen = win:screen():frame_without_dock_or_menu()
  local f = win:frame()
  f.x = screen.w / 2 - (f.w / 2)
  f.y = screen.h / 2 - (f.h / 2)
  win:setframe(f)
end

function movewindow_lefthalf()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  win:setframe(newframe)
end

function movewindow_righthalf()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.x = newframe.w
  win:setframe(newframe)
end


function movewindow_tophalf()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.h = newframe.h / 2
  win:setframe(newframe)
end

function movewindow_bottomhalf()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.h = newframe.h / 2
  newframe.y = newframe.h + (win:screen():frame_including_dock_and_menu().h -
                                win:screen():frame_without_dock_or_menu().h)
  win:setframe(newframe)
end

function movewindow_topleft()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  win:setframe(newframe)
end

function movewindow_bottomleft()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  newframe.y = newframe.h + (win:screen():frame_including_dock_and_menu().h -
                                win:screen():frame_without_dock_or_menu().h)
  win:setframe(newframe)
end

function movewindow_bottomright()
  local win = window.focusedwindow()
  local newframe = win:screen():frame_without_dock_or_menu()
  newframe.w = newframe.w / 2
  newframe.h = newframe.h / 2
  newframe.x = newframe.w
  newframe.y = newframe.h + (win:screen():frame_including_dock_and_menu().h -
                                win:screen():frame_without_dock_or_menu().h)
  win:setframe(newframe)
end

function movewindow_topright()
  local win = window.focusedwindow()
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

