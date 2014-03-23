// Shiftit
// http://code.google.com/p/shiftit/wiki/HotKeys

// Hot Keys
// 
// Half Screen Actions:
// Left Half - alt+cmd+left arrow
// Right Half - alt+cmd+right arrow
// Bottom Half - alt+cmd+down arrow
// Top Half - alt+cmd+up arrow
// 
// Quarter Screen Actions:
// Top Left - ctrl+alt+cmd+left arrow
// Top Right - ctrl+alt+cmd+up arrow
// Bottom right - ctrl+alt+cmd+right arrow
// Bottom left - ctrl+alt+cmd+down arrow
// 
// Other Actions:
// Full Screen - alt+cmd+F
// Center - alt+cmd+C

var mash = ['cmd', 'alt'];
var mashmash = ['cmd', 'alt', 'ctrl'];

bind('R', mashmash, function() {reloadConfig();});
bind('F', mash, function() {api.focusedWindow().maximize();});

// Center window
bind('C', mash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  var winframe = win.frame();
  winframe.x = frame.w / 2 - (winframe.w / 2);
  winframe.y = frame.h / 2 - (winframe.h / 2);
  win.setFrame(winframe);
});

bind('left', mash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameIncludingDockAndMenu();
  frame.w /= 2;
  win.setFrame(frame);
});

bind('right', mash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.w /= 2;
  frame.x = frame.w;
  win.setFrame(frame);
});

bind('up', mash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.h /= 2;
  win.setFrame(frame);
});

bind('down', mash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.h /= 2;
  frame.y = frame.h + (win.screen().frameIncludingDockAndMenu().h -
                        win.screen().frameWithoutDockOrMenu().h);
  win.setFrame(frame);
});


bind('left', mashmash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.w /= 2;
  frame.h /= 2;
  win.setFrame(frame);
});

bind('right', mashmash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.w /= 2;
  frame.h /= 2;
  frame.x = frame.w;
  frame.y = frame.h + (win.screen().frameIncludingDockAndMenu().h -
                        win.screen().frameWithoutDockOrMenu().h);
  win.setFrame(frame);
});

bind('up', mashmash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.w /= 2;
  frame.h /= 2;
  frame.x = frame.w;
  win.setFrame(frame);
});

bind('down', mashmash, function() {
  var win = api.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.w /= 2;
  frame.h /= 2;
  frame.y = frame.h + (win.screen().frameIncludingDockAndMenu().h -
                        win.screen().frameWithoutDockOrMenu().h);
  win.setFrame(frame);
});


