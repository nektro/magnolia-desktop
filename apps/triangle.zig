const std = @import("std");
const mag = @import("magnolia");
const build_options = @import("build_options");
const gl = mag.gl;

const App = mag.App(&.{Client});
const root = @This();

pub fn main() !void {
    var app = try App.init(undefined, .{}, 800, 600, build_options.name);
    defer app.deinit();

    try app.start(mag.Color.parseConst("#000000"));
    try app.draw();
    try app.run();
}

const Client = struct {
    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        _ = self;
        _ = x;
        _ = y;
        _ = width;
        _ = height;
        const w = app.win_width;
        const h = app.win_height;
        gl.draw(&.{
            gl.vertexc(0, h, 1, 0, 0),
            gl.vertexc(w / 2, 0, 0, 1, 0),
            gl.vertexc(w, h, 0, 0, 1),
        });
    }
};
