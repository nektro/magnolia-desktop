const Row = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");

children: []const mag.Node,

pub fn new(app: *root.App, children: []const mag.Node) !mag.Node {
    return try app.newNode(Row{ .children = try app.alloc.dupe(mag.Node, children) });
}

pub fn draw(self: Row, app: root.App, px: u32, y: u32, width: u32, height: u32) !void {
    const w = width / @intCast(u32, self.children.len);
    for (self.children) |item, i| {
        try app.drawNode(item, px + @intCast(u32, w * i), y, w, height);
    }
}
