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
        self.font = try mag.bdf.parse(app.alloc, "Cozette/cozette.bdf");

        self.child = try mag.DynGrid.new(app, .{ 9, 1, .{ .margin = 10, .font = &self.font, .fontScale = 2 }, &.{
            try mag.TextLine.new(app, .{ .{}, "Cozette v.1.13.0" }),
            try mag.TextLine.new(app, .{ .{}, " " }),
            try mag.TextLine.new(app, .{ .{}, "Aa Bb Cc Dd Ee Ff Gg Hh Ii Jj Kk Ll Mm Nn Oo Pp Qq Rr Ss Tt Uu Vv Ww Xx Yy Zz" }),
            try mag.TextLine.new(app, .{ .{}, " " }),
            try mag.TextLine.new(app, .{ .{}, "0 1 2 3 4 5 6 7 8 9" }),
            try mag.TextLine.new(app, .{ .{}, " " }),
            try mag.TextLine.new(app, .{ .{}, "The quick brown fox jumps over the lazy dog." }),
            try mag.TextLine.new(app, .{ .{}, " " }),
            try mag.TextLine.new(app, .{ .{}, "! @ # $ % ^ & * ( ) : ; [ ] { } \" ' - = _ + ` ~ < > / ? , ." }),
        } });
        app.cascadeNodeStyles(null, self.child.?);
    }

    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        try app.drawNode(self.child.?, x, y, width, height);
    }
};
