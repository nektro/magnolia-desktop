const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");
const gl = mag.gl;

width: u32,
height: u32,
style: mag.style.ForNode,

pub fn drawAbs(self: Self, top_left: mag.Point, color: ?mag.Color) void {
    if (color == null) return;

    const xf = top_left.x;
    const yf = top_left.y;
    const wf = self.width;
    const hf = self.height;

    const x1 = xf;
    const y1 = yf;
    const x2 = xf + wf;
    const y2 = yf + hf;

    gl.draw(&.{
        gl.vertexc(x1, y1, color.?.r, color.?.g, color.?.b),
        gl.vertexp(x2, y1),
        gl.vertexp(x2, y2),
        gl.vertexp(x1, y2),
    });
}

usingnamespace mag.MixinNodeInit(Self);

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    _ = app;
    var copy = self;
    if (copy.width == 0) copy.width = width;
    if (copy.height == 0) copy.height = height;
    drawAbs(copy, .{ .x = x, .y = y }, null);
}

pub fn getMinWidth(self: Self, app: root.App) u32 {
    _ = app;
    return self.width;
}

pub fn getMinHeight(self: Self, app: root.App) u32 {
    _ = app;
    return self.height;
}
