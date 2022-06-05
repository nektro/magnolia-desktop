const std = @import("std");
const root = @import("root");
const extras = @import("extras");

pub const c = @import("./c.zig");
pub const x11 = @import("./x11.zig");
pub const glx = @import("./glx.zig");
pub const gl = @import("./gl.zig");
pub const style = @import("./style.zig");
pub const bdf = @import("./bdf.zig");

pub const Point = @import("./Point.zig");
pub const Color = @import("./Color.zig");
pub const Rect = @import("./Rect.zig");
pub const NodeItem = *anyopaque;
pub const Node = enum(u32) { _ };
pub const StrictGrid = @import("./StrictGrid.zig");
pub const Row = @import("./Row.zig");
pub const DynGrid = @import("./DynGrid.zig");
pub const TextLine = @import("./TextLine.zig");

pub fn App(comptime Elements: []const type) type {
    const Client = Elements[0];
    const Builtins = [_]type{
        StrictGrid,
        Row,
        DynGrid,
        Rect,
        TextLine,
    };
    const AllElements = &Builtins ++ Elements[1..];
    return struct {
        display: x11.Display,
        visual: glx.Visual,
        window: x11.Window,
        client: Client,
        win_width: u32,
        win_height: u32,
        center: Point,
        active: bool,
        alloc: std.mem.Allocator,
        nodes: std.AutoHashMapUnmanaged(Node, NodeItem),
        types: std.AutoHashMapUnmanaged(Node, u32),

        const Self = @This();

        var nextId: u32 = 0;

        pub fn init(alloc: std.mem.Allocator, client: Client) !Self {
            // Open the display
            const display = try x11.Display.init();

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
            const window = try x11.Window.init(display, visual);

            return Self{
                .display = display,
                .visual = visual,
                .window = window,
                .client = client,
                .win_width = 800,
                .win_height = 600,
                .center = .{ .x = 400, .y = 300 },
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
            self.freeNodes();
            self.nodes.deinit(self.alloc);
            self.types.deinit(self.alloc);
            if (@hasDecl(Client, "deinit")) self.client.deinit(self.alloc);
        }

        pub fn start(self: Self, bg: Color) !void {
            std.log.debug("GL Vendor: {s}", .{gl.String.vendor.get()});
            std.log.debug("GL Renderer: {s}", .{gl.String.renderer.get()});
            std.log.debug("GL Version: {s}", .{gl.String.version.get()});
            std.log.debug("GL Extensions: {d}", .{gl.String.extensionCount()});

            try self.window.enableEvents();

            try self.window.show();

            c.glClearColor(bg.r, bg.g, bg.b, 1);
            c.glTranslatef(-1, 1, 0);
            c.glScalef(2.0 / @intToFloat(f32, self.win_width), -2.0 / @intToFloat(f32, self.win_height), 0.0);
        }

        pub fn run(self: *Self) !void {
            var ev: c.XEvent = undefined;
            var running = true;
            var str: [25]u8 = undefined;
            var len: usize = 0;
            var keysym: c.KeySym = 0;

            while (running) {
                _ = c.XNextEvent(self.window.display, &ev);

                switch (@intToEnum(x11.EventType, ev.type)) {
                    .expose => {
                        const attribs = self.window.attributes();
                        const w = @intCast(u32, attribs.width);
                        const h = @intCast(u32, attribs.height);
                        const dx = @intToFloat(f32, self.win_width) / @intToFloat(f32, w);
                        const dy = @intToFloat(f32, self.win_height) / @intToFloat(f32, h);
                        c.glViewport(0, 0, attribs.width, attribs.height);
                        c.glScalef(dx, dy, 1);

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
                    const r = @intToEnum(Node, nextId);
                    defer nextId += 1;
                    const t = try self.alloc.create(IT);
                    t.* = element;
                    try self.nodes.put(self.alloc, r, t);
                    try self.types.put(self.alloc, r, i);
                    return r;
                }
            }
            @compileError(@typeName(ET) ++ " not found in list of provided element types");
        }

        fn freeNodes(self: *Self) void {
            var it = self.nodes.keyIterator();
            while (it.next()) |node| {
                const rawptr = self.nodes.get(node.*).?;
                const i = self.types.get(node.*).?;
                inline for (AllElements) |T, j| {
                    if (i == j) {
                        const elem = extras.ptrCast(T, rawptr);
                        elem.deinit(self.alloc);
                        self.alloc.destroy(elem);
                    }
                }
            }
        }

        pub fn drawNode(self: Self, node: Node, x: u32, y: u32, width: u32, height: u32) anyerror!void {
            if (width == 0) return;
            if (height == 0) return;
            inline for (AllElements) |T, j| {
                if (self.types.get(node).? == j) {
                    const elem = extras.ptrCast(T, self.nodes.get(node).?);
                    const margin = elem.style.calcMargin();

                    const t = margin.top;
                    const l = margin.left;
                    const b = margin.bottom;
                    const r = margin.right;
                    Rect.drawAbs(
                        .{
                            .width = width - margin.left - margin.right,
                            .height = height - margin.top - margin.bottom,
                            .style = .{},
                        },
                        .{
                            .x = x + margin.top,
                            .y = y + margin.left,
                        },
                        elem.style.bgcolor,
                    );
                    try elem.draw(
                        self,
                        x + t,
                        y + l,
                        width - l - r,
                        height - t - b,
                    );
                    return;
                }
            }
            unreachable;
        }

        pub fn assertNodeType(self: Self, node: Node, comptime T: type) void {
            inline for (AllElements) |E, j| {
                if (self.types.get(node).? == j) {
                    std.debug.assert(T == E);
                    return;
                }
            }
            unreachable;
        }

        pub fn castNodeAs(self: Self, node: Node, comptime T: type) *T {
            self.assertNodeType(node, T);
            return extras.ptrCast(T, self.nodes.items[@enumToInt(node)]);
        }

        pub fn getNodeWidth(self: Self, node: Node) u32 {
            inline for (AllElements) |T, j| {
                if (self.types.get(node).? == j) {
                    return extras.ptrCast(T, self.nodes.get(node).?).getWidth(self);
                }
            }
            unreachable;
        }

        pub fn getNodeHeight(self: Self, node: Node) u32 {
            inline for (AllElements) |T, j| {
                if (self.types.get(node).? == j) {
                    return extras.ptrCast(T, self.nodes.get(node).?).getHeight(self);
                }
            }
            unreachable;
        }

        pub fn cascadeNodeStyles(self: *Self, parent_styles: ?style.ForNode, node: Node) void {
            const parent = parent_styles orelse style.ForNode{};

            inline for (AllElements) |T, j| {
                if (self.types.get(node).? == j) {
                    const entry = self.nodes.getEntry(node).?;
                    var element = extras.ptrCast(T, entry.value_ptr.*);
                    element.style.merge(parent);
                    entry.value_ptr.* = element;

                    if (@hasField(T, "children")) {
                        for (element.children) |child| {
                            self.cascadeNodeStyles(element.style, child);
                        }
                    }
                    return;
                }
            }
            unreachable;
        }
    };
}

pub fn MixinNodeInit(comptime T: type) type {
    return struct {
        pub fn new(app: *root.App, args: extras.FieldsTuple(T)) std.mem.Allocator.Error!Node {
            var t: T = undefined;
            inline for (std.meta.fields(T)) |item, i| {
                const direct = args[i];
                const F = item.field_type;
                const item_is_slice = comptime std.meta.trait.isSlice(F);
                const value = if (item_is_slice) try app.alloc.dupe(std.meta.Child(F), direct) else direct;
                @field(t, item.name) = value;
            }
            return try app.newNode(t);
        }

        pub fn deinit(self: T, alloc: std.mem.Allocator) void {
            inline for (std.meta.fields(T)) |item| {
                if (comptime std.meta.trait.isSlice(item.field_type)) {
                    alloc.free(@field(self, item.name));
                }
            }
        }
    };
}

// TODO make this a union when we support more formats
pub const Font = bdf.Font;
