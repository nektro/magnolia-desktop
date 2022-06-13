const std = @import("std");
const mag = @import("magnolia");

pub const App = mag.App(&.{
    Client,
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 8 }){};
    defer std.debug.assert(!gpa.deinit());
    const alloc = gpa.allocator();

    var app = try App.init(alloc, .{});
    defer app.deinit();

    try app.client.postinit(&app);
    try app.start(mag.Color.parseConst("#000000"));
    try app.draw();
    try app.run();
}

const Client = struct {
    child: ?mag.Node = null,

    pub fn postinit(self: *Client, app: *App) !void {
        self.child = try mag.Rect.new(app, .{ 150, 150, .{
            .bgcolor = .{ .r = 1, .g = 0, .b = 0 },
            .halign = .center,
            .valign = .center,
        } });
        app.cascadeNodeStyles(null, self.child.?);
    }

    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        try app.drawNode(self.child.?, x, y, width, height);
    }
};
