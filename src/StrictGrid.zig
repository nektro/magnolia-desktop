const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");

style: mag.style.ForNode,
children: []const mag.Node,

// needs to do assert
// usingnamespace mag.MixinNodeInit(Self);

pub fn new(app: *root.App, style: mag.style.ForNode, children: []const mag.Node) !mag.Node {
    for (children) |item| app.assertNodeType(item, mag.Row);
    return try app.newNode(Self{ .style = style, .children = try app.alloc.dupe(mag.Node, children) });
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

pub usingnamespace mag.MixinNodeMinWidthChildSum(Self);
pub usingnamespace mag.MixinNodeMinHeightChildSum(Self);

pub fn getWidth(self: Self, app: root.App, available: u32) u32 {
    _ = self;
    _ = app;
    return available;
}
pub fn getHeight(self: Self, app: root.App, available: u32) u32 {
    _ = self;
    _ = app;
    return available;
}
