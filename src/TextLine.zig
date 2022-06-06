const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");
const range = @import("range").range;
const extras = @import("extras");

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
    while (iter.nextCodepoint()) |cp| {
        const char = self.style.font.?.getChar(@intCast(u16, cp));
        for (range(char.height * scale)) |_, py| {
            for (range(char.width * scale)) |_, px| {
                if (!char.bits[extras.d2index(char.height, py / scale, px / scale)]) continue;
                try pts.append(mag.gl.vertexp(
                    x + dx + @intCast(u32, px),
                    y + @intCast(u32, py),
                ));
            }
        }
        dx += char.width * scale;
    }
    mag.gl.color3(0, 0, 0);
    mag.gl.drawPoints(pts.items);
}

pub fn getWidth(self: Self, app: root.App) u32 {
    _ = app;
    var res: u32 = 0;
    var iter = std.unicode.Utf8View.initUnchecked(self.text).iterator();
    while (iter.nextCodepoint()) |cp| {
        const char = self.style.font.?.getChar(@intCast(u16, cp));
        res += char.width;
    }
    return res * scale;
}

pub fn getHeight(self: Self, app: root.App) u32 {
    _ = app;
    return self.style.font.?.h * scale;
}
