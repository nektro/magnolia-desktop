const Self = @This();
const std = @import("std");
const root = @import("root");
const mag = @import("./main.zig");

r: f32, // red value (bounded between 0 and 1)
g: f32, // green value (bounded between 0 and 1)
b: f32, // blue value (bounded between 0 and 1)

pub fn parseConst(comptime inp: *const [7:0]u8) Self {
    comptime std.debug.assert(inp[0] == '#');
    return Self{
        .r = comptime @intToFloat(f32, std.fmt.parseInt(u8, inp[1..3], 16) catch unreachable) / 255.0,
        .g = comptime @intToFloat(f32, std.fmt.parseInt(u8, inp[3..5], 16) catch unreachable) / 255.0,
        .b = comptime @intToFloat(f32, std.fmt.parseInt(u8, inp[5..7], 16) catch unreachable) / 255.0,
    };
}

pub fn eql(self: Self, other: Self) bool {
    return self.r == other.r and self.g == other.g and self.b == other.b;
}
