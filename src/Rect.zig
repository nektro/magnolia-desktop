const Rect = @This();
const mag = @import("./main.zig");
const gl = mag.gl;

top_left: mag.Point,
width: u32,
height: u32,
color: mag.Color,

pub fn draw(self: Rect, win_width: u32, win_height: u32) void {
    const wwf = @intToFloat(f32, win_width);
    const whf = @intToFloat(f32, win_height);

    const xf = @intToFloat(f32, self.top_left.x);
    const yf = @intToFloat(f32, self.top_left.y);
    const wf = @intToFloat(f32, self.width);
    const hf = @intToFloat(f32, self.height);

    const x1 = xf / wwf;
    const y1 = yf / whf;
    const x2 = (xf + wf) / wwf;
    const y2 = (yf + hf) / whf;

    var pts: @Vector(8, f32) = .{ x1, y1, x2, y1, x2, y2, x1, y2 };
    pts *= @splat(8, @as(f32, 2));
    pts -= @splat(8, @as(f32, 1));

    gl.draw(&.{
        gl.vertexc(pts[0], -pts[1], self.color.r, self.color.g, self.color.b),
        gl.vertexp(pts[2], -pts[3]),
        gl.vertexp(pts[4], -pts[5]),
        gl.vertexp(pts[6], -pts[7]),
    });
}