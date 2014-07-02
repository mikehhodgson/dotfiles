api.bind('E', ['cmd'], function() {
        var win = Window.focusedWindow();
        var frame = win.frame();
        frame.x += 10;
        frame.height -= 10;
        win.setFrame(frame);
        return true;
    });
