const std = @import("std");
const mag = @import("./main.zig");

pub const ForNode = struct {
    margin: u32 = 0,
    vhmargin: [2]u32 = .{ 0, 0 },
    tmargin: u32 = 0,
    bmargin: u32 = 0,
    lmargin: u32 = 0,
    rmargin: u32 = 0,

    bgcolor: ?mag.Color = null,

    pub fn calcMargin(self: ForNode) Box {
        return .{
            .top = o(self.tmargin) orelse o(self.vhmargin[0]) orelse o(self.margin) orelse 0,
            .bottom = o(self.bmargin) orelse o(self.vhmargin[0]) orelse o(self.margin) orelse 0,
            .left = o(self.lmargin) orelse o(self.vhmargin[1]) orelse o(self.margin) orelse 0,
            .right = o(self.rmargin) orelse o(self.vhmargin[1]) orelse o(self.margin) orelse 0,
        };
    }
};

pub const Box = struct {
    top: u32,
    bottom: u32,
    left: u32,
    right: u32,

    pub fn array(self: Box) [4]u32 {
        return .{
            self.top,
            self.right,
            self.bottom,
            self.left,
        };
    }
};

fn o(x: u32) ?u32 {
    return if (x > 0) x else null;
}
