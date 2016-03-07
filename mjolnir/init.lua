--https://luarocks.org/search?q=mjolnir
--luarocks install mjolnir.hotkey
--luarocks install mjolnir.application
--luarocks install mjolnir.alert

local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
--local alert = require "mjolnir.alert"

hotkey.bind({"cmd", "alt", "ctrl"}, "D", function()
  local win = window.focusedwindow()
  local f = win:frame()
  f.x = f.x + 10
  win:setframe(f)
end)


function bindkeys()
   local mash = {"cmd", "alt"}
   local mashmash = {"cmd", "ctrl", "alt"}

   hotkey.bind(mash, "r", mjolnir.reload)
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


function movewindow(...)
   local functions = {...}
   local win = window.focusedwindow()
   if not win then return end
   local frame = win:screen():frame()
   for k, v in pairs(functions) do
      frame = v(frame)
   end
   win:setframe(frame)
end

function maximise()
   movewindow()
end

function center(...)
   local frame = select(1, ...)
   if frame then
      local win = window.focusedwindow()
      if not win then return end
      local screen = win:screen():frame()
      frame = win:frame()
      if not frame then return end
      if not screen then return end
      frame.x = screen.w / 2 - (frame.w / 2)
      frame.y = screen.h / 2 - (frame.h / 2)
      return frame
   else
      movewindow(center)
   end
end

-- if no argument, pushes focused window left
-- if pass a screen frame, make it left and return it
function left(...)
   local frame = select(1, ...)
   if frame then
      frame.w = frame.w / 2
      return frame
   else
      movewindow(left)
   end
end

function right(...)
   local frame = select(1, ...)
   if frame then
      frame.w = frame.w / 2
      frame.x = frame.w
      return frame
   else
      movewindow(right)
   end
end

function top(...)
   local frame = select(1, ...)
   if frame then
      frame.h = frame.h / 2
      return frame
   else
      movewindow(top)
   end
end

function bottom(...)
   local frame = select(1, ...)
   if frame then
      frame.h = frame.h / 2
      frame.y = frame.y + frame.h  -- account for menu bar
      return frame
   else
      movewindow(bottom)
   end
end

function topleft()
   movewindow(top, left)
end

function bottomleft()
   movewindow(bottom, left)
end

function bottomright()
   movewindow(bottom, right)
end

function topright()
   movewindow(top, right)
end

bindkeys()
