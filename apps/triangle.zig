const std = @import("std");
const mag = @import("magnolia");

const c = mag.c;
const gl = mag.gl;

pub fn main() !void {
    var client = try Client.init();
    defer client.deinit();

    var app = try mag.App(Client).init(client);
    defer app.deinit();

    try app.start();

    draw(app.window);

    try app.run();
}

pub const Client = struct {
    //

    const Self = @This();

    pub fn init() !Self {
        return Self{
            //
        };
    }

    pub fn deinit(self: Self) void {
        _ = self;
    }

    pub fn handleResize(self: Self, xwindow: mag.x.Window, width: u32, height: u32) !void {
        _ = self;
        _ = width;
        _ = height;
        draw(xwindow);
    }
};

fn draw(xwindow: mag.x.Window) void {
    // OpenGL Rendering
    gl.clear(.color);

    gl.draw(.TRIANGLES, &.{
        gl.vertexc(-1, -1, 1, 0, 0),
        gl.vertexc(0, 1, 0, 1, 0),
        gl.vertexc(1, -1, 0, 0, 1),
    });

    // Present frame
    c.glXSwapBuffers(xwindow.display, xwindow.window);
}
