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
        self.child = try mag.StrictGrid.new(app, &.{
            try mag.Row.new(app, &.{
                try mag.Color.parseConst("#27AE60").new(app),
                try mag.Color.parseConst("#2980B9").new(app),
            }),
            try mag.Row.new(app, &.{
                try mag.Color.parseConst("#E67E22").new(app),
                try mag.Color.parseConst("#E74C3C").new(app),
            }),
        });
    }

    pub fn draw(self: Client, app: App, x: u32, y: u32, width: u32, height: u32) !void {
        try app.drawNode(self.child.?, x, y, width, height);
    }
};
