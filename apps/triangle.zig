const std = @import("std");
const mag = @import("magnolia");
const gl = mag.gl;

const App = mag.App(Client);

pub fn main() !void {
    var app = try mag.App(Client).init(.{});
    defer app.deinit();

    try app.start();

    draw(app);

    try app.run();
}

const Client = struct {
    const Self = @This();
    pub fn handleResize(self: Self, app: App) !void {
        _ = self;
        draw(app);
    }
};

fn draw(app: App) void {
    gl.clear(.color);

    gl.draw(&.{
        gl.vertexc(-1, -1, 1, 0, 0),
        gl.vertexc(0, 1, 0, 1, 0),
        gl.vertexc(1, -1, 0, 0, 1),
    });

    gl.commitFrame(app.window);
}
