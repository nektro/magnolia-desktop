const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");

children: []const mag.Node,

// needs to do assert
// usingnamespace mag.MixinNodeInit(Self);

pub fn new(app: *root.App, children: []const mag.Node) !mag.Node {
    for (children) |item| app.assertNodeType(item, mag.Row);
    return try app.newNode(Self{ .children = try app.alloc.dupe(mag.Node, children) });
}

pub fn deinit(self: Self, alloc: std.mem.Allocator) void {
    alloc.free(self.children);
}

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    const h = height / @intCast(u32, self.children.len);
    for (self.children) |item, i| {
        try app.drawNode(item, x, y + @intCast(u32, h * i), width, h);
    }
}

pub fn getWidth(self: Self, app: root.App) u32 {
    _ = self;
    _ = app;
    std.debug.todo("StrictGrid.getWidth");
}

pub fn getHeight(self: Self, app: root.App) u32 {
    _ = self;
    _ = app;
    std.debug.todo("StrictGrid.getHeight");
}
