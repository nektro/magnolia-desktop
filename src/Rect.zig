const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");
const gl = mag.gl;

width: u32,
height: u32,
color: ?mag.Color,

pub fn drawAbs(self: Self, top_left: mag.Point) void {
    if (self.color == null) return;
    const color = self.color.?;

    const xf = @intToFloat(f32, top_left.x);
    const yf = @intToFloat(f32, top_left.y);
    const wf = @intToFloat(f32, self.width);
    const hf = @intToFloat(f32, self.height);

    const x1 = xf;
    const y1 = yf;
    const x2 = xf + wf;
    const y2 = yf + hf;

    gl.draw(&.{
        gl.vertexc(x1, y1, color.r, color.g, color.b),
        gl.vertexp(x2, y1),
        gl.vertexp(x2, y2),
        gl.vertexp(x1, y2),
    });
}

usingnamespace mag.MixinNodeInit(Self);

// Size is transparent, nothing to draw
pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    _ = self;
    _ = app;
    _ = x;
    _ = y;
    _ = width;
    _ = height;
}

pub fn getWidth(self: Self, app: root.App) u32 {
    _ = app;
    return self.width;
}

pub fn getHeight(self: Self, app: root.App) u32 {
    _ = app;
    return self.height;
}
