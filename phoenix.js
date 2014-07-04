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

// TODO - diagnose multimonitor issues with snapping right

var mash = ['cmd', 'alt'];
var mashmash = ['cmd', 'alt', 'ctrl'];

api.bind('F', mashmash, function() {Window.focusedWindow().maximize();});

// Center window
api.bind('C', mashmash, function() {
  var window = Window.focusedWindow();
  var screen = window.screen().frameWithoutDockOrMenu();
  var frame = window.frame();
  frame.x = screen.width / 2 - (frame.width / 2);
  frame.y = screen.height / 2 - (frame.height / 2);
  window.setFrame(frame);
});

// Snap left half
api.bind('left', mash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameIncludingDockAndMenu();
  frame.width /= 2;
  win.setFrame(frame);
});

// Snap right half
api.bind('right', mash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.width /= 2;
  frame.x = frame.width;
  win.setFrame(frame);
});

// Snap top half
api.bind('up', mash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.height /= 2;
  win.setFrame(frame);
});

// Snap bottom half
api.bind('down', mash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.height /= 2;
  frame.y = frame.height + (win.screen().frameIncludingDockAndMenu().height -
                        win.screen().frameWithoutDockOrMenu().height);
  win.setFrame(frame);
});

// Snap top left
api.bind('left', mashmash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.width /= 2;
  frame.height /= 2;
  win.setFrame(frame);
});

// Snap bottom right
api.bind('right', mashmash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.width /= 2;
  frame.height /= 2;
  frame.x = frame.width;
  frame.y = frame.height + (win.screen().frameIncludingDockAndMenu().height -
                        win.screen().frameWithoutDockOrMenu().height);
  win.setFrame(frame);
});

// Snap top right
api.bind('up', mashmash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.width /= 2;
  frame.height /= 2;
  frame.x = frame.width;
  win.setFrame(frame);
});

// Snap bottom left
api.bind('down', mashmash, function() {
  var win = Window.focusedWindow();
  var frame = win.screen().frameWithoutDockOrMenu();
  frame.width /= 2;
  frame.height /= 2;
  frame.y = frame.height + (win.screen().frameIncludingDockAndMenu().height -
                        win.screen().frameWithoutDockOrMenu().height);
  win.setFrame(frame);
});


