const std = @import("std");
const mag = @import("magnolia");
const build_options = @import("build_options");

pub const App = mag.App(&.{
    Client,
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 8 }){};
    defer std.debug.assert(!gpa.deinit());
    const alloc = gpa.allocator();

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
        self.child = try mag.DynGrid.new(app, .{
            2, 2, .{}, &.{
                try mag.Rect.new(app, .{ 200, 50, .{} }),
                try mag.Rect.new(app, .{ 0, 0, .{ .bgcolor = mag.Color.parseConst("#CFD8DC") } }),
                try mag.Rect.new(app, .{ 0, 0, .{ .bgcolor = mag.Color.parseConst("#CFD8DC") } }),
                try mag.Rect.new(app, .{ 0, 0, .{ .bgcolor = mag.Color.parseConst("#90A4AE") } }),
            },
        });
    }

    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        try app.drawNode(self.child.?, x, y, width, height);
    }
};
