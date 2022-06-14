const std = @import("std");
const builtin = @import("builtin");
const mag = @import("magnolia");
const build_options = @import("build_options");

pub const App = mag.App(&.{
    Client,
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 8 }){};
    defer std.debug.assert(!gpa.deinit());
    const alloc = if (builtin.mode == .Debug) gpa.allocator() else std.heap.c_allocator;

    var app = try App.init(alloc, .{}, 800, 600, build_options.name);
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
