const std = @import("std");
const root = @import("root");

pub const c = @import("./c.zig");
pub const x = @import("./x.zig");
pub const glx = @import("./glx.zig");
pub const gl = @import("./gl.zig");
pub const Point = @import("./Point.zig");
pub const Color = @import("./Color.zig");
pub const Rect = @import("./Rect.zig");
pub const NodeItem = *anyopaque;
pub const Node = enum(u32) { _ };

pub fn App(comptime Elements: []const type) type {
    const Client = Elements[0];
    const Builtins = &[_]type{
        Grid,
        Row,
        Color,
    };
    const AllElements = Builtins ++ Elements;
    return struct {
        display: x.Display,
        visual: glx.Visual,
        window: x.Window,
        client: Client,
        win_width: u32,
        win_height: u32,
        center: Point,
        active: bool,
        alloc: std.mem.Allocator,
        nodes: std.ArrayListUnmanaged(NodeItem),
        types: std.ArrayListUnmanaged(u32),

        const Self = @This();

        pub fn init(alloc: std.mem.Allocator, client: Client) !Self {
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
                .alloc = alloc,
                .nodes = .{},
                .types = .{},
            };
        }

        pub fn deinit(self: *Self) void {
            self.window.deinit();
            self.visual.deinit();
            self.display.deinit();
            // TODO: free items in self.nodes
            self.nodes.deinit(self.alloc);
            self.types.deinit(self.alloc);
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

                switch (@intToEnum(x.EventType, ev.type)) {
                    .expose => {
                        const attribs = self.window.attributes();
                        c.glViewport(0, 0, attribs.width, attribs.height);

                        const w = @intCast(u32, attribs.width);
                        const h = @intCast(u32, attribs.height);

                        self.win_width = w;
                        self.win_height = h;
                        self.center.x = w / 2;
                        self.center.y = h / 2;

                        if (@hasDecl(Client, "handleResize")) try self.client.handleResize(self.*);
                        // expose means all window content has been lost, trigger a manual full draw
                        try self.draw();
                    },
                    .keymap_notify => {
                        _ = c.XRefreshKeyboardMapping(&ev.xmapping);
                    },
                    .key_press => {
                        if (!self.active) continue;
                        len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                        if (len > 0) {
                            // std.log.debug("key pressed: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                            std.log.debug("key down: {d}", .{keysym});
                        }
                    },
                    .key_release => {
                        if (!self.active) continue;
                        len = @intCast(usize, c.XLookupString(&ev.xkey, &str, 25, &keysym, null));
                        if (len > 0) {
                            // std.log.debug("key released: {s} - {d} - {d}", .{ str[0..len], len, keysym });
                            std.log.debug("key up: {d}", .{keysym});
                        }
                    },
                    .destroy_notify => {
                        if (!self.active) continue;
                        running = false;
                    },
                    .client_message => {
                        if (!self.active) continue;
                        if (ev.xclient.data.l[0] == self.window.atom) {
                            running = false;
                        }
                    },
                    .enter_notify => {
                        self.active = true;
                        if (@hasDecl(Client, "handleEnter")) try self.client.handleEnter(self.*);
                    },
                    .leave_notify => {
                        self.active = false;
                        if (@hasDecl(Client, "handleLeave")) try self.client.handleLeave(self.*);
                    },
                    .button_press => {
                        if (!self.active) continue;
                    },
                    .button_release => {
                        if (!self.active) continue;
                    },
                    .motion_notify => {
                        if (!self.active) continue;
                    },
                    else => {
                        std.log.info("unrecognized event: {d}", .{ev.type});
                    },
                }
            }
        }

        pub fn draw(self: Self) !void {
            gl.clear(.color);
            try self.client.draw(self, 0, 0, self.win_width, self.win_height);
            gl.commitFrame(self.window);
        }

        pub fn newNode(self: *Self, element: anytype) !Node {
            const ET = @TypeOf(element);
            inline for (AllElements) |IT, i| {
                if (ET == IT) {
                    const r = self.nodes.items.len;
                    const t = try self.alloc.create(IT);
                    t.* = element;
                    try self.nodes.append(self.alloc, t);
                    try self.types.append(self.alloc, i);
                    return @intToEnum(Node, r);
                }
            }
            @compileError(@typeName(ET) ++ " not found in list of provided element types");
        }

        pub fn drawNode(self: Self, node: Node, px: u32, py: u32, width: u32, height: u32) anyerror!void {
            const i = @enumToInt(node);

            inline for (AllElements) |T, j| {
                if (self.types.items[i] == j) {
                    const elem = @ptrCast(*T, @alignCast(@alignOf(T), self.nodes.items[i]));
                    try elem.draw(self, px, py, width, height);
                    return;
                }
            }
            unreachable;
        }
    };
}

const RootApp = root.App;

pub const Grid = struct {
    children: []const Node,

    pub fn new(app: *RootApp, children: []const Node) !Node {
        // TODO assert .children are all Row
        return try app.newNode(Grid{ .children = try app.alloc.dupe(Node, children) });
    }

    pub fn draw(self: Grid, app: RootApp, px: u32, y: u32, width: u32, height: u32) !void {
        const h = height / @intCast(u32, self.children.len);
        for (self.children) |item, i| {
            try app.drawNode(item, px, y + @intCast(u32, h * i), width, h);
        }
    }
};

pub const Row = struct {
    children: []const Node,

    pub fn new(app: *RootApp, children: []const Node) !Node {
        return try app.newNode(Row{ .children = try app.alloc.dupe(Node, children) });
    }

    pub fn draw(self: Row, app: RootApp, px: u32, y: u32, width: u32, height: u32) !void {
        const w = width / @intCast(u32, self.children.len);
        for (self.children) |item, i| {
            try app.drawNode(item, px + @intCast(u32, w * i), y, w, height);
        }
    }
};
