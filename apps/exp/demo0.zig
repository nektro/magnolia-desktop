const std = @import("std");

const c = @cImport({
    @cInclude("X11/Xlib.h");
    @cInclude("X11/Xutil.h");
    @cInclude("X11/keysymdef.h");
    @cInclude("GL/gl.h");
    @cInclude("GL/glx.h");
});

pub fn main() !void {

    // Open the display
    const display = c.XOpenDisplay(null).?;
    defer _ = c.XCloseDisplay(display);

    // const screen = DefaultScreenOfDisplay(display);
    const screenId = DefaultScreen(display);

    // Check GLX version
    var majorGLX: c_int = 0;
    var minorGLX: c_int = 0;
    _ = c.glXQueryVersion(display, &majorGLX, &minorGLX);
    if (!(majorGLX >= 1 and minorGLX >= 2)) {
        std.log.err("GLX 1.2 or greater is required.", .{});
        return;
    }
    std.log.debug("GLX version: {d}.{d}", .{ majorGLX, minorGLX });

    // GLX, create XVisualInfo, this is the minimum visuals we want
    // zig fmt: off
    var glxAttribs = [_]c.GLint{
        c.GLX_RGBA,
        c.GLX_DOUBLEBUFFER,
        c.GLX_DEPTH_SIZE,     24,
        c.GLX_STENCIL_SIZE,   8,
        c.GLX_RED_SIZE,       8,
        c.GLX_GREEN_SIZE,     8,
        c.GLX_BLUE_SIZE,      8,
        c.GLX_SAMPLE_BUFFERS, 0,
        c.GLX_SAMPLES,        0,
        c.None
    };
    // zig fmt: on
    const visual = c.glXChooseVisual(display, screenId, &glxAttribs);
    defer _ = c.XFree(visual);
    if (visual == null) return;

    // Open the window
    var windowAttribs: c.XSetWindowAttributes = undefined;
    windowAttribs.border_pixel = BlackPixel(display, screenId);
    windowAttribs.background_pixel = WhitePixel(display, screenId);
    windowAttribs.override_redirect = 1;
    windowAttribs.colormap = c.XCreateColormap(display, RootWindow(display, screenId), visual.*.visual, c.AllocNone);
    windowAttribs.event_mask = c.ExposureMask;
    defer _ = c.XFreeColormap(display, windowAttribs.colormap);

    const window = c.XCreateWindow(display, RootWindow(display, screenId), 0, 0, 320, 200, 0, visual.*.depth, c.InputOutput, visual.*.visual, c.CWBackPixel | c.CWColormap | c.CWBorderPixel | c.CWEventMask, &windowAttribs);
    defer _ = c.XDestroyWindow(display, window);

    // Redirect Close
    var atomWmDeleteWindow = c.XInternAtom(display, "WM_DELETE_WINDOW", 0);
    _ = c.XSetWMProtocols(display, window, &atomWmDeleteWindow, 1);

    // Create GLX OpenGL context
    const context = c.glXCreateContext(display, visual, null, 1);
    defer c.glXDestroyContext(display, context);
    _ = c.glXMakeCurrent(display, window, context);

    std.log.debug("GL Vendor: {s}", .{c.glGetString(c.GL_VENDOR)});
    std.log.debug("GL Renderer: {s}", .{c.glGetString(c.GL_RENDERER)});
    std.log.debug("GL Version: {s}", .{c.glGetString(c.GL_VERSION)});
    std.log.debug("GL Shading Language: {s}", .{c.glGetString(c.GL_SHADING_LANGUAGE_VERSION)});

    // register we want keyboard input
    _ = c.XSelectInput(display, window, c.KeyPressMask | c.KeyReleaseMask | c.KeymapStateMask);

    // Show the window
    _ = c.XClearWindow(display, window);
    _ = c.XMapRaised(display, window);

    // Set GL Sample stuff
    c.glClearColor(0.5, 0.6, 0.7, 1.0);

    // Enter message loop
    var ev: c.XEvent = undefined;
    var running = true;
    var str: [25]u8 = undefined;
    var len: usize = 0;
    var keysym: c.KeySym = 0;

    while (running) {
        _ = c.XNextEvent(display, &ev);

        switch (ev.type) {
            c.Expose => {
                var attribs: c.XWindowAttributes = undefined;
                _ = c.XGetWindowAttributes(display, window, &attribs);
                c.glViewport(0, 0, attribs.width, attribs.height);
            },
            c.KeymapNotify => {
                _ = c.XRefreshKeyboardMapping(&ev.xmapping);
            },
            c.KeyPress => {
                len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                if (keysym == c.XK_Escape) {
                    running = false;
                    break;
                }
                if (len > 0) {
                    // std.log.debug("key pressed: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                    std.log.debug("key down: {d}", .{keysym});
                }
            },
            c.KeyRelease => {
                len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                if (keysym == c.XK_Escape) {
                    break;
                }
                if (len > 0) {
                    // std.log.debug("key released: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                    std.log.debug("key up: {d}", .{keysym});
                }
            },
            c.DestroyNotify => {
                running = false;
                break;
            },
            c.ClientMessage => {
                if (ev.xclient.data.l[0] == atomWmDeleteWindow) {
                    running = false;
                    break;
                }
            },
            else => {
                std.log.info("unrecognized event: {d}", .{ev.type});
            },
        }

        // OpenGL Rendering
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glBegin(c.GL_TRIANGLES);
        c.glColor3f(1.0, 0.0, 0.0);
        c.glVertex3f(0.0, -1.0, 0.0);
        c.glColor3f(0.0, 1.0, 0.0);
        c.glVertex3f(-1.0, 1.0, 0.0);
        c.glColor3f(0.0, 0.0, 1.0);
        c.glVertex3f(1.0, 1.0, 0.0);
        c.glEnd();

        // Present frame
        c.glXSwapBuffers(display, window);
    }
}

// #define DefaultScreenOfDisplay(dpy) ScreenOfDisplay(dpy,DefaultScreen(dpy
// #define ScreenOfDisplay(dpy, scr)(&((_XPrivDisplay)(dpy))->screens[scr])
// #define DefaultScreen(dpy)     (((_XPrivDisplay)(dpy))->default_screen)
fn DefaultScreenOfDisplay(dpy: *c.Display) *c.Screen {
    return ScreenOfDisplay(dpy, DefaultScreen(dpy));
}
fn ScreenOfDisplay(dpy: *c.Display, scr: c_int) *c.Screen {
    return std.zig.c_translation.cast(c._XPrivDisplay, dpy).*.screens + @intCast(usize, scr);
}
fn DefaultScreen(dpy: *c.Display) c_int {
    return std.zig.c_translation.cast(c._XPrivDisplay, dpy).*.default_screen;
}

// #define BlackPixel(dpy, scr)     (ScreenOfDisplay(dpy,scr)->black_pixel)
// #define WhitePixel(dpy, scr)     (ScreenOfDisplay(dpy,scr)->white_pixel)
fn BlackPixel(dpy: *c.Display, scr: c_int) c_ulong {
    return ScreenOfDisplay(dpy, scr).*.black_pixel;
}
fn WhitePixel(dpy: *c.Display, scr: c_int) c_ulong {
    return ScreenOfDisplay(dpy, scr).*.white_pixel;
}

// #define RootWindow(dpy, scr) 	(ScreenOfDisplay(dpy,scr)->root)
fn RootWindow(dpy: *c.Display, scr: c_int) c.Window {
    return ScreenOfDisplay(dpy, scr).*.root;
}
