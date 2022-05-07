const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");
const range = @import("range").range;

rows: u16,
cols: u16,
children: []const mag.Node,

pub fn new(app: *root.App, rows: u16, cols: u16, children: []const mag.Node) !mag.Node {
    return try app.newNode(Self{ .rows = rows, .cols = cols, .children = try app.alloc.dupe(mag.Node, children) });
}

pub fn deinit(self: Self, alloc: std.mem.Allocator) void {
    alloc.free(self.children);
}

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    _ = width;
    _ = height;

    var dx = x;
    for (range(self.cols)) |_, c| {
        const cc = @intCast(u16, c);
        const w = if (cc == self.cols - 1) (width - dx) else self.getMaxWidth(app, cc);
        defer dx += w;

        var dy = y;
        for (range(self.rows)) |_, r| {
            const rr = @intCast(u16, r);
            const h = if (rr == self.rows - 1) (height - dy) else self.getMaxHeight(app, rr);
            defer dy += h;

            try app.drawNode(self.child(cc, rr), dx, dy, w, h);
        }
    }
}

fn child(self: Self, col: u16, row: u16) mag.Node {
    return self.children[(self.cols * row) + col];
}

fn getMaxWidth(self: Self, app: root.App, col: u16) u32 {
    var ret: u32 = 0;
    for (range(self.rows)) |_, r| {
        ret = std.math.max(ret, app.getNodeWidth(self.child(col, @intCast(u16, r))));
    }
    return ret;
}

fn getMaxHeight(self: Self, app: root.App, row: u16) u32 {
    var ret: u32 = 0;
    for (range(self.cols)) |_, c| {
        ret = std.math.max(ret, app.getNodeHeight(self.child(@intCast(u16, c), row)));
    }
    return ret;
}

pub fn getWidth(self: Self, app: root.App) u32 {
    _ = self;
    _ = app;
    std.debug.todo("DynGrid.getWidth");
}

pub fn getHeight(self: Self, app: root.App) u32 {
    _ = self;
    _ = app;
    std.debug.todo("DynGrid.getHeight");
}
