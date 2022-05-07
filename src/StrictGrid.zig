const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");

children: []const mag.Node,

pub fn new(app: *root.App, children: []const mag.Node) !mag.Node {
    // TODO assert .children are all Row
    return try app.newNode(Self{ .children = try app.alloc.dupe(mag.Node, children) });
}

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    const h = height / @intCast(u32, self.children.len);
    for (self.children) |item, i| {
        try app.drawNode(item, x, y + @intCast(u32, h * i), width, h);
    }
}
