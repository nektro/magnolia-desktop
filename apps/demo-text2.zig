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
    try app.start(mag.Color.parseConst("#ffffff"));
    try app.draw();
    try app.run();
}

const Client = struct {
    child: ?mag.Node = null,
    font: mag.Font = undefined,

    pub fn deinit(self: *Client, alloc: std.mem.Allocator) void {
        self.font.deinit(alloc);
    }

    pub fn postinit(self: *Client, app: *App) !void {
        self.font = try mag.bdf.parse(app.alloc, build_options.font);

        self.child = try mag.DynGrid.new(app, .{ 1, 1, .{ .margin = 10, .font = &self.font, .fontScale = 2 }, &.{
            try mag.TextFlow.new(app, .{ .{}, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." }),
        } });
        app.cascadeNodeStyles(null, self.child.?);
    }

    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        try app.drawNode(self.child.?, x, y, width, height);
    }
};
