const std = @import("std");

pub const c = @import("./c.zig");
pub const x = @import("./x.zig");
pub const glx = @import("./glx.zig");
pub const gl = @import("./gl.zig");

pub fn App(comptime Client: type) type {
    return struct {
        display: x.Display,
        visual: glx.Visual,
        window: x.Window,
        client: Client,
        win_width: u32,
        win_height: u32,
        center: Point,

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
                        var attribs: c.XWindowAttributes = undefined;
                        _ = c.XGetWindowAttributes(self.window.display, self.window.window, &attribs);
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
                        len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                        if (len > 0) {
                            // std.log.debug("key pressed: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                            std.log.debug("key down: {d}", .{keysym});
                        }
                    },
                    c.KeyRelease => {
                        len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                        if (len > 0) {
                            // std.log.debug("key released: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                            std.log.debug("key up: {d}", .{keysym});
                        }
                    },
                    c.DestroyNotify => {
                        running = false;
                    },
                    c.ClientMessage => {
                        if (ev.xclient.data.l[0] == self.window.atom) {
                            running = false;
                        }
                    },
                    c.ButtonPress => {},
                    c.ButtonRelease => {},
                    c.MotionNotify => {},
                    c.EnterNotify => {
                        if (@hasDecl(Client, "handleEnter")) try self.client.handleEnter(self.*);
                    },
                    c.LeaveNotify => {
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

pub const Point = struct {
    x: u32,
    y: u32,
};

pub const Color = struct {
    r: f32, // red value (bounded between 0 and 1)
    g: f32, // green value (bounded between 0 and 1)
    b: f32, // blue value (bounded between 0 and 1)

    pub fn parseConst(comptime inp: *const [7:0]u8) Color {
        comptime std.debug.assert(inp[0] == '#');
        return Color{
            .r = comptime @intToFloat(f32, std.fmt.parseInt(u8, inp[1..3], 16) catch unreachable) / 255.0,
            .g = comptime @intToFloat(f32, std.fmt.parseInt(u8, inp[3..5], 16) catch unreachable) / 255.0,
            .b = comptime @intToFloat(f32, std.fmt.parseInt(u8, inp[5..7], 16) catch unreachable) / 255.0,
        };
    }
};

pub const Rect = struct {
    top_left: Point,
    width: u32,
    height: u32,
    color: Color,

    pub fn draw(self: Rect, win_width: u32, win_height: u32) void {
        const wwf = @intToFloat(f32, win_width);
        const whf = @intToFloat(f32, win_height);

        const xf = @intToFloat(f32, self.top_left.x);
        const yf = @intToFloat(f32, self.top_left.y);
        const wf = @intToFloat(f32, self.width);
        const hf = @intToFloat(f32, self.height);

        const x1 = xf / wwf;
        const y1 = yf / whf;
        const x2 = (xf + wf) / wwf;
        const y2 = (yf + hf) / whf;

        var pts: @Vector(8, f32) = .{ x1, y1, x2, y1, x2, y2, x1, y2 };
        pts *= @splat(8, @as(f32, 2));
        pts -= @splat(8, @as(f32, 1));

        gl.draw(&.{
            gl.vertexc(pts[0], -pts[1], self.color.r, self.color.g, self.color.b),
            gl.vertexp(pts[2], -pts[3]),
            gl.vertexp(pts[4], -pts[5]),
            gl.vertexp(pts[6], -pts[7]),
        });
    }
};
