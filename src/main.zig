const std = @import("std");

pub const c = @import("./c.zig");
pub const x = @import("./x.zig");
pub const glx = @import("./glx.zig");
pub const gl = @import("./gl.zig");
pub const Point = @import("./Point.zig");
pub const Color = @import("./Color.zig");
pub const Rect = @import("./Rect.zig");

pub fn App(comptime Client: type) type {
    return struct {
        display: x.Display,
        visual: glx.Visual,
        window: x.Window,
        client: Client,
        win_width: u32,
        win_height: u32,
        center: Point,
        active: bool,

        const Self = @This();

        pub fn init(client: Client) !Self {
            // Open the display
            const display = try x.Display.init();

            // Check GLX version
            if (!glx.isAtLeast(display, 1, 2)) {
                std.log.err("GLX 1.2 or greater is required.", .{});
                return error.BadGlxVersion;
            }
            const glxv = glx.version(display).?;
            std.log.debug("GLX version: {d}.{d}", .{ glxv.major, glxv.minor });

            // GLX, create XVisualInfo, this is the minimum visuals we want
            const visual = try glx.Visual.init(display);

            // Open the window
            const window = try x.Window.init(display, visual);

            return Self{
                .display = display,
                .visual = visual,
                .window = window,
                .client = client,
                .win_width = 0,
                .win_height = 0,
                .center = .{ .x = 0, .y = 0 },
                .active = false,
            };
        }

        pub fn deinit(self: Self) void {
            self.window.deinit();
            self.visual.deinit();
            self.display.deinit();
        }

        pub fn start(self: Self) !void {
            std.log.debug("GL Vendor: {s}", .{gl.String.vendor.get()});
            std.log.debug("GL Renderer: {s}", .{gl.String.renderer.get()});
            std.log.debug("GL Version: {s}", .{gl.String.version.get()});
            std.log.debug("GL Extensions: {d}", .{gl.String.extensionCount()});

            try self.window.enableEvents();

            try self.window.show();

            c.glClearColor(0, 0, 0, 1);
        }

        pub fn run(self: *Self) !void {
            var ev: c.XEvent = undefined;
            var running = true;
            var str: [25]u8 = undefined;
            var len: usize = 0;
            var keysym: c.KeySym = 0;

            while (running) {
                _ = c.XNextEvent(self.window.display, &ev);

                switch (ev.type) {
                    c.Expose => {
                        const attribs = self.window.attributes();
                        c.glViewport(0, 0, attribs.width, attribs.height);

                        const w = @intCast(u32, attribs.width);
                        const h = @intCast(u32, attribs.height);

                        if (w == self.win_width and h == self.win_height) return;
                        self.win_width = w;
                        self.win_height = h;
                        self.center.x = w / 2;
                        self.center.y = h / 2;

                        try self.client.handleResize(self.*);
                    },
                    c.KeymapNotify => {
                        _ = c.XRefreshKeyboardMapping(&ev.xmapping);
                    },
                    c.KeyPress => {
                        if (!self.active) continue;
                        len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                        if (len > 0) {
                            // std.log.debug("key pressed: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                            std.log.debug("key down: {d}", .{keysym});
                        }
                    },
                    c.KeyRelease => {
                        if (!self.active) continue;
                        len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                        if (len > 0) {
                            // std.log.debug("key released: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                            std.log.debug("key up: {d}", .{keysym});
                        }
                    },
                    c.DestroyNotify => {
                        if (!self.active) continue;
                        running = false;
                    },
                    c.ClientMessage => {
                        if (!self.active) continue;
                        if (ev.xclient.data.l[0] == self.window.atom) {
                            running = false;
                        }
                    },
                    c.ButtonPress => {},
                    c.ButtonRelease => {},
                    c.MotionNotify => {},
                    c.EnterNotify => {
                        self.active = true;
                        if (@hasDecl(Client, "handleEnter")) try self.client.handleEnter(self.*);
                    },
                    c.LeaveNotify => {
                        self.active = false;
                        if (@hasDecl(Client, "handleLeave")) try self.client.handleLeave(self.*);
                    },
                    else => {
                        std.log.info("unrecognized event: {d}", .{ev.type});
                    },
                }
            }
        }
    };
}
