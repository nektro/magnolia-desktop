// mask   | EnterWindowMask | LeaveWindowMask
// events | EnterNotify     | LeaveNotify

const std = @import("std");
const mag = @import("magnolia");
const gl = mag.gl;

const App = mag.App(Client);

const Client = struct {
    rect: mag.Rect,

    const Self = @This();

    pub fn init() !Self {
        return Self{
            .rect = .{
                .top_left = .{ .x = 0, .y = 0 },
                .width = 0,
                .height = 0,
                .color = .{ .r = 0, .g = 1, .b = 0 },
            },
        };
    }

    pub fn deinit(self: Self) void {
        _ = self;
    }

    pub fn draw(self: Self, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        _ = x;
        _ = y;
        _ = width;
        _ = height;
        self.rect.draw(app.win_width, app.win_height);
    }

    pub fn handleResize(self: *Self, app: App) !void {
        self.rect.width = app.win_width;
        self.rect.height = app.win_height;
    }

    pub fn handleEnter(self: *Self, app: App) !void {
        self.rect.color = mag.Color.parseConst("#2ECC71");

        try app.draw();
    }

    pub fn handleLeave(self: *Self, app: App) !void {
        self.rect.color = mag.Color.parseConst("#E74C3C");

        try app.draw();
    }
};

pub fn main() !void {
    var client = try Client.init();
    defer client.deinit();

    var app = try mag.App(Client).init(client);
    defer app.deinit();

    try app.start();

    try app.draw();

    try app.run();
}
