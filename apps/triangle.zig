const std = @import("std");
const mag = @import("magnolia");

const c = mag.c;

pub fn main() !void {

    // Open the display
    const xdisplay = try mag.x.Display.init();
    defer xdisplay.deinit();

    // Check GLX version
    if (!mag.glx.isAtLeast(xdisplay, 1, 2)) {
        std.log.err("GLX 1.2 or greater is required.", .{});
        return;
    }
    const glxv = mag.glx.version(xdisplay).?;
    std.log.debug("GLX version: {d}.{d}", .{ glxv.major, glxv.minor });

    // GLX, create XVisualInfo, this is the minimum visuals we want
    const xvisual = try mag.glx.Visual.init(xdisplay);
    defer xvisual.deinit();

    // Open the window
    const xwindow = try mag.x.Window.init(xdisplay, xvisual);
    defer xwindow.deinit();

    // Create GLX OpenGL context
    const context = c.glXCreateContext(xdisplay.display, xvisual.visual, null, 1);
    defer c.glXDestroyContext(xdisplay.display, context);
    _ = c.glXMakeCurrent(xdisplay.display, xwindow.window, context);

    std.log.debug("GL Vendor: {s}", .{c.glGetString(c.GL_VENDOR)});
    std.log.debug("GL Renderer: {s}", .{c.glGetString(c.GL_RENDERER)});
    std.log.debug("GL Version: {s}", .{c.glGetString(c.GL_VERSION)});
    std.log.debug("GL Shading Language: {s}", .{c.glGetString(c.GL_SHADING_LANGUAGE_VERSION)});

    // register we want keyboard input
    _ = c.XSelectInput(xdisplay.display, xwindow.window, c.KeyPressMask | c.KeyReleaseMask | c.KeymapStateMask);

    // Show the window
    _ = c.XClearWindow(xdisplay.display, xwindow.window);
    _ = c.XMapRaised(xdisplay.display, xwindow.window);

    // Set GL Sample stuff
    c.glClearColor(0.5, 0.6, 0.7, 1.0);

    // Enter message loop
    var ev: c.XEvent = undefined;
    var running = true;
    var str: [25]u8 = undefined;
    var len: usize = 0;
    var keysym: c.KeySym = 0;

    while (running) {
        _ = c.XNextEvent(xdisplay.display, &ev);

        switch (ev.type) {
            c.Expose => {
                var attribs: c.XWindowAttributes = undefined;
                _ = c.XGetWindowAttributes(xdisplay.display, xwindow.window, &attribs);
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
                if (ev.xclient.data.l[0] == xwindow.atom) {
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
        c.glXSwapBuffers(xdisplay.display, xwindow.window);
    }
}