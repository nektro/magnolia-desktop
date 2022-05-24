const std = @import("std");
const mag = @import("magnolia");

pub const App = mag.App(&.{
    Client,
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!gpa.deinit());
    const alloc = gpa.allocator();

    var app = try App.init(alloc, .{});
    defer app.deinit();

    try app.client.postinit(&app);

    try app.start();
    try app.draw();
    try app.run();
}

const Client = struct {
    child: ?mag.Node = null,

    pub fn postinit(self: *Client, app: *App) !void {
        self.child = try mag.DynGrid.new(app, .{ 1, 1, .{ .margin = 20, .bgcolor = mag.Color.parseConst("#27AE60") }, &.{
            try mag.DynGrid.new(app, .{ 1, 1, .{ .margin = 20, .bgcolor = mag.Color.parseConst("#2980B9") }, &.{
                try mag.DynGrid.new(app, .{ 1, 1, .{ .margin = 20, .bgcolor = mag.Color.parseConst("#E67E22") }, &.{
                    try mag.DynGrid.new(app, .{ 1, 1, .{ .margin = 20, .bgcolor = mag.Color.parseConst("#E74C3C") }, &.{
                        try mag.Rect.new(app, .{ 0, 0, .{ .margin = 10, .bgcolor = mag.Color.parseConst("#F1C40F") } }),
                    } }),
                } }),
            } }),
        } });
    }

    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        try app.drawNode(self.child.?, x, y, width, height);
    }
};
