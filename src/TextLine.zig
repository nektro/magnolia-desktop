const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");
const range = @import("range").range;

style: mag.style.ForNode,
text: []const u8,

usingnamespace mag.MixinNodeInit(Self);
const scale = 2;

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    _ = self;
    _ = app;
    _ = x;
    _ = y;
    _ = width;
    _ = height;

    var pts = std.ArrayList(mag.gl.Path.Item).init(app.alloc);
    defer pts.deinit();
    var iter = std.unicode.Utf8View.initUnchecked(self.text).iterator();
    var dx: u32 = 0;
    while (iter.nextCodepoint()) |cp| : (dx += self.style.font.?.w) {
        const ons = self.style.font.?.drawChar(@intCast(u16, cp), scale);
        for (ons) |col, py| {
            for (col) |row, px| {
                if (!row) continue;
                try pts.append(mag.gl.vertexp(
                    x + dx + @intCast(u32, px),
                    y + @intCast(u32, py),
                ));
            }
        }
    }
    mag.gl.color3(0, 0, 0);
    mag.gl.drawPoints(pts.items);
}

pub fn getWidth(self: Self, app: root.App) u32 {
    _ = app;
    return self.style.font.?.w * @intCast(u32, self.text.len) * scale;
}

pub fn getHeight(self: Self, app: root.App) u32 {
    _ = app;
    return self.style.font.?.h * scale;
}
