const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");
const range = @import("range").range;
const extras = @import("extras");

style: mag.style.ForNode,
text: []const u8,

usingnamespace mag.MixinNodeInit(Self);

pub fn draw(self: Self, app: root.App, x: u32, y: u32, width: u32, height: u32) !void {
    _ = width;
    _ = height;

    const font = self.style.font.?;
    const fh = font.properties.ints.get("CAP_HEIGHT").? + 1;
    const min_width = @intCast(u8, font.properties.ints.get("FIGURE_WIDTH").?);
    const scale = self.style.fontScale;

    var pts = std.ArrayList(mag.gl.Path.Item).init(app.alloc);
    defer pts.deinit();
    var iter = std.unicode.Utf8View.initUnchecked(self.text).iterator();
    var dx: u32 = 0;
    while (iter.nextCodepoint()) |cp| {
        const char = font.getChar(@intCast(u16, cp));
        const cx = (char.ll_x - 1) * @as(i9, scale);
        const cy = (-char.ll_y + fh - char.height) * @as(i9, scale);

        for (range(char.height * scale)) |_, py| {
            for (range(char.width * scale)) |_, px| {
                if (!char.bits[py / scale].isSet(char.width - 1 - (px / scale) + char.start)) continue;
                try pts.append(mag.gl.vertexp(
                    add(x, cx) + dx + @intCast(u32, px),
                    add(y, cy) + @intCast(u32, py),
                ));
            }
        }
        dx += std.math.max(char.width, min_width) * scale;
    }
    mag.gl.color3(0, 0, 0);
    mag.gl.drawPoints(pts.items);
}

fn add(a: u32, b: i32) u32 {
    if (b >= 0) {
        return a + @intCast(u31, b);
    }
    return a - @intCast(u31, -b);
}

pub fn getWidth(self: Self, app: root.App) u32 {
    _ = app;
    const font = self.style.font.?;
    const scale = self.style.fontScale;
    const min_width = @intCast(u8, font.properties.ints.get("FIGURE_WIDTH").?);
    var res: u32 = 0;
    var iter = std.unicode.Utf8View.initUnchecked(self.text).iterator();
    while (iter.nextCodepoint()) |cp| {
        const char = self.style.font.?.getChar(@intCast(u16, cp));
        res += std.math.max(char.width, min_width);
    }
    return res * scale;
}

pub fn getHeight(self: Self, app: root.App) u32 {
    _ = app;
    const scale = self.style.fontScale;
    return self.style.font.?.h * scale;
}
