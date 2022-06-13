// mask   | EnterWindowMask | LeaveWindowMask
// events | EnterNotify     | LeaveNotify

const std = @import("std");
const mag = @import("magnolia");
const build_options = @import("build_options");
const gl = mag.gl;

const App = mag.App(&.{Client});

const Client = struct {
    rect: mag.Rect,

    const Self = @This();

    pub fn init() Self {
        return Self{
            .rect = .{
                .width = 0,
                .height = 0,
                .style = .{ .bgcolor = .{ .r = 1, .g = 1, .b = 1 } },
            },
        };
    }

    pub fn draw(self: Self, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        _ = app;
        _ = width;
        _ = height;
        self.rect.drawAbs(.{ .x = x, .y = y }, self.rect.style.bgcolor);
    }

    pub fn handleResize(self: *Self, app: App) !void {
        self.rect.width = app.win_width;
        self.rect.height = app.win_height;
    }

    pub fn handleEnter(self: *Self, app: App) !void {
        self.rect.style.bgcolor = mag.Color.parseConst("#2ECC71");

        try app.draw();
    }

    pub fn handleLeave(self: *Self, app: App) !void {
        self.rect.style.bgcolor = mag.Color.parseConst("#E74C3C");

        try app.draw();
    }
};

pub fn main() !void {
    var app = try App.init(undefined, Client.init(), 800, 600, build_options.name);
    defer app.deinit();

    try app.start(mag.Color.parseConst("#000000"));
    try app.draw();
    try app.run();
}
