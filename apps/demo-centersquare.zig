const std = @import("std");
const mag = @import("magnolia");
const gl = mag.gl;

const App = mag.App(&.{Client});

const Client = struct {
    top_left: mag.Point,
    rect: mag.Rect,

    const Self = @This();

    pub fn init() !Self {
        return Self{
            .top_left = .{ .x = 0, .y = 0 },
            .rect = .{
                .width = 150,
                .height = 150,
                .color = .{ .r = 1, .g = 0, .b = 0 },
            },
        };
    }

    pub fn deinit(self: Self) void {
        _ = self;
    }

    pub fn draw(self: Self, app: App, x: u32, y: u32, width: u32, height: u32) error{}!void {
        _ = app;
        _ = x;
        _ = y;
        _ = width;
        _ = height;
        self.rect.drawAbs(self.top_left, app.win_width, app.win_height);
    }

    pub fn handleResize(self: *Self, app: App) !void {
        self.top_left.x = app.center.x - (self.rect.width / 2);
        self.top_left.y = app.center.y - (self.rect.height / 2);
    }
};

pub fn main() !void {
    var client = try Client.init();
    defer client.deinit();

    var app = try App.init(undefined, client);
    defer app.deinit();

    try app.start();

    try app.draw();

    try app.run();
}
