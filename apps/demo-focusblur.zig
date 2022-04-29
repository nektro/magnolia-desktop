// mask   | EnterWindowMask | LeaveWindowMask
// events | EnterNotify     | LeaveNotify

// On ButtonPress and ButtonRelease the event object will contains an xbutton field.
// This field has a button variable, which maps as follows:
//      1 - left mouse
//      2 - middle mouse
//      3 - right mouse
//      4 - scroll up
//      5 - scroll down.

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
                .top_left = .{},
                .width = 0,
                .height = 0,
                .color = .{ .r = 0, .g = 1, .b = 0 },
            },
        };
    }

    pub fn deinit(self: Self) void {
        _ = self;
    }

    fn draw(self: Self, app: App) void {
        gl.clear(.color);

        self.rect.draw(app.win_width, app.win_height);

        gl.commitFrame(app.window);
    }

    pub fn handleResize(self: *Self, app: App) !void {
        self.rect.width = app.win_width;
        self.rect.height = app.win_height;

        self.draw(app);
    }

    pub fn handleEnter(self: *Self, app: App) !void {
        // #2ECC71
        self.rect.color.r = 0.18;
        self.rect.color.g = 0.80;
        self.rect.color.b = 0.443;

        self.draw(app);
    }

    pub fn handleLeave(self: *Self, app: App) !void {
        // #E74C3C
        self.rect.color.r = 0.906;
        self.rect.color.g = 0.298;
        self.rect.color.b = 0.235;

        self.draw(app);
    }
};

pub fn main() !void {
    var client = try Client.init();
    defer client.deinit();

    var app = try mag.App(Client).init(client);
    defer app.deinit();

    try app.start();

    client.draw(app);

    try app.run();
}
