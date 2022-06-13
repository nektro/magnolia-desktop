const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");

style: mag.style.ForNode,
children: []const mag.Node,

usingnamespace mag.MixinNodeInit(Self);

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    const w = width / @intCast(u32, self.children.len);
    for (self.children) |item, i| {
        try app.drawNode(item, x + @intCast(u32, w * i), y, w, height);
    }
}

pub usingnamespace mag.MixinNodeMinWidthChildSum(Self);
pub usingnamespace mag.MixinNodeMinHeightChildSum(Self);
