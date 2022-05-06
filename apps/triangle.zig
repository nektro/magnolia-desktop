const std = @import("std");
const mag = @import("magnolia");
const gl = mag.gl;

const App = mag.App(&.{Client});
const root = @This();

pub fn main() !void {
    var app = try App.init(undefined, .{});
    defer app.deinit();

    try app.start();

    draw(app);

    try app.run();
}

const Client = struct {
    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        _ = self;
        _ = x;
        _ = y;
        _ = width;
        _ = height;
        root.draw(app);
    }
};

fn draw(app: App) void {
    _ = app;
    gl.draw(&.{
        gl.vertexc(-1, -1, 1, 0, 0),
        gl.vertexc(0, 1, 0, 1, 0),
        gl.vertexc(1, -1, 0, 0, 1),
    });
}
