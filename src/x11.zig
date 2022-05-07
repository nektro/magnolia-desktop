const std = @import("std");

const c = @import("./c.zig");
const glx = @import("./glx.zig");

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

pub const Window = struct {
    display: *c.Display,
    attribs: c.XSetWindowAttributes,
    window: c.Window,
    atom: c.Atom,

    pub fn init(xdisplay: Display, xvisual: glx.Visual) !Window {
        const dpy = xdisplay.display;

        var attribs: c.XSetWindowAttributes = undefined;
        attribs.border_pixel = xdisplay.blackPixel();
        attribs.background_pixel = xdisplay.whitePixel();
        attribs.override_redirect = 1;
        // TODO: handle C error
        attribs.colormap = c.XCreateColormap(dpy, xdisplay.rootWindow(), xvisual.visual, c.AllocNone);
        attribs.event_mask = c.ExposureMask;

        // TODO: handle C error
        const win = c.XCreateWindow(xdisplay.display, xdisplay.rootWindow(), 0, 0, 800, 600, 0, xvisual.info.*.depth, c.InputOutput, xvisual.visual, c.CWBackPixel | c.CWColormap | c.CWBorderPixel | c.CWEventMask, &attribs);

        // allow X to intercept user hitting window 'close' button
        // TODO: handle C error
        var atom = c.XInternAtom(dpy, "WM_DELETE_WINDOW", 0);
        _ = c.XSetWMProtocols(dpy, win, &atom, 1);

        // Create GLX OpenGL context
        // TODO: maybe move this to glx namespace
        // TODO: handle C errors
        const context = c.glXCreateContext(dpy, xvisual.info, null, 1);
        defer c.glXDestroyContext(dpy, context);
        _ = c.glXMakeCurrent(dpy, win, context);

        return Window{
            .display = dpy,
            .attribs = attribs,
            .window = win,
            .atom = atom,
        };
    }

    pub fn deinit(self: Window) void {
        // TODO: investigate possible return values
        _ = c.XFreeColormap(self.display, self.attribs.colormap);
        _ = c.XDestroyWindow(self.display, self.window);
    }

    pub fn enableEvents(self: Window) !void {
        const mask_keys = c.KeymapStateMask | c.KeyPressMask | c.KeyReleaseMask;
        const mask_btns = c.ButtonPressMask | c.ButtonReleaseMask;
        const mask_mouse = c.PointerMotionMask;
        const mask_focus = c.EnterWindowMask | c.LeaveWindowMask;
        const mask = mask_keys | mask_btns | mask_mouse | mask_focus;

        // TODO: handle C error
        _ = c.XSelectInput(self.display, self.window, c.ExposureMask | mask);
    }

    pub fn show(self: Window) !void {
        // TODO: handle C error
        _ = c.XClearWindow(self.display, self.window);
        _ = c.XMapRaised(self.display, self.window);
    }

    pub fn attributes(self: Window) c.XWindowAttributes {
        var attribs: c.XWindowAttributes = undefined;
        // TODO: investigate possible return values
        _ = c.XGetWindowAttributes(self.display, self.window, &attribs);
        return attribs;
    }
};

pub const EventType = enum(c_int) {
    key_press = 2,
    key_release = 3,
    button_press = 4,
    button_release = 5,
    motion_notify = 6,
    enter_notify = 7,
    leave_notify = 8,
    focus_in = 9,
    focus_out = 10,
    keymap_notify = 11,
    expose = 12,
    graphics_expose = 13,
    no_expose = 14,
    visibility_notify = 15,
    create_notify = 16,
    destroy_notify = 17,
    unmap_notify = 18,
    map_notify = 19,
    map_request = 20,
    reparent_notify = 21,
    configure_notify = 22,
    configure_request = 23,
    gravity_notify = 24,
    resize_request = 25,
    circulate_notify = 26,
    circulate_request = 27,
    property_notify = 28,
    selection_clear = 29,
    selection_request = 30,
    selection_notify = 31,
    colormap_notify = 32,
    client_message = 33,
    mapping_notify = 34,
    generic_event = 35,
};
