const std = @import("std");

const c = @import("./c.zig");

pub const Display = struct {
    display: *c.Display,
    screenId: c_int,
    screen: *c.Screen,

    pub fn init() !Display {
        // TODO: handle C error
        const disp = c.XOpenDisplay(null).?;
        const sid = DefaultScreen(disp);

        return Display{
            .display = disp,
            .screenId = sid,
            .screen = ScreenOfDisplay(disp, sid),
        };
    }

    pub fn deinit(self: Display) void {
        // TODO: investigate possible return values
        _ = c.XCloseDisplay(self.display);
    }

    pub fn blackPixel(self: Display) c_ulong {
        // #define BlackPixel(dpy, scr)     (ScreenOfDisplay(dpy,scr)->black_pixel)
        return self.screen.*.black_pixel;
    }

    pub fn whitePixel(self: Display) c_ulong {
        // #define WhitePixel(dpy, scr)     (ScreenOfDisplay(dpy,scr)->white_pixel)
        return self.screen.*.white_pixel;
    }

    pub fn rootWindow(self: Display) c.Window {
        // #define RootWindow(dpy, scr) 	(ScreenOfDisplay(dpy,scr)->root)
        return self.screen.*.root;
    }
};

// #define DefaultScreen(dpy)     (((_XPrivDisplay)(dpy))->default_screen)
fn DefaultScreen(dpy: *c.Display) c_int {
    return std.zig.c_translation.cast(c._XPrivDisplay, dpy).*.default_screen;
}

// #define ScreenOfDisplay(dpy, scr)(&((_XPrivDisplay)(dpy))->screens[scr])
fn ScreenOfDisplay(dpy: *c.Display, scr: c_int) *c.Screen {
    return std.zig.c_translation.cast(c._XPrivDisplay, dpy).*.screens + @intCast(usize, scr);
}
