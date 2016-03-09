hs.window.animationDuration = 0 -- disable animations

function bindkeys()
   local mash = {"cmd", "alt"}
   local mashmash = {"cmd", "ctrl", "alt"}

   hs.hotkey.bind(mash, "r", hs.reload)
   hs.hotkey.bind(mashmash, "f", maximise)
   hs.hotkey.bind(mashmash, "c", center)
   hs.hotkey.bind(mash, "left", left)
   hs.hotkey.bind(mash, "right", right)
   hs.hotkey.bind(mash, "up", top)
   hs.hotkey.bind(mash, "down", bottom)
   hs.hotkey.bind(mashmash, "left", bottomleft)
   hs.hotkey.bind(mashmash, "right", topright)
   hs.hotkey.bind(mashmash, "up", topleft)
   hs.hotkey.bind(mashmash, "down", bottomright)
end


function movewindow(...)
   local functions = {...}
   local win = hs.window.focusedWindow()
   if not win then return end
   local frame = win:screen():frame()
   for k, v in pairs(functions) do
      frame = v(frame)
   end
   win:setFrame(frame)
end

function maximise()
   movewindow()
end

function center(...)
   local frame = select(1, ...)
   if frame then
      local win = hs.window.focusedWindow()
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
