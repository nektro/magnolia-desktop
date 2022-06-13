const std = @import("std");
const mag = @import("./main.zig");
const extras = @import("extras");

pub const ForNode = struct {
    margin: u32 = 0,
    vhmargin: [2]u32 = .{ 0, 0 },
    tmargin: u32 = 0,
    bmargin: u32 = 0,
    lmargin: u32 = 0,
    rmargin: u32 = 0,
    bgcolor: ?mag.Color = null,
    halign: enum { left, center, right } = .left,
    valign: enum { top, center, bottom } = .top,

    font: ?*mag.Font = null,
    fontScale: u8 = 1,
    fontColor: mag.Color = mag.Color.parseConst("#000000"),

    pub fn calcMargin(self: ForNode) Box {
        return .{
            .top = o(self.tmargin) orelse o(self.vhmargin[0]) orelse o(self.margin) orelse 0,
            .bottom = o(self.bmargin) orelse o(self.vhmargin[0]) orelse o(self.margin) orelse 0,
            .left = o(self.lmargin) orelse o(self.vhmargin[1]) orelse o(self.margin) orelse 0,
            .right = o(self.rmargin) orelse o(self.vhmargin[1]) orelse o(self.margin) orelse 0,
        };
    }

    pub fn merge(self: *ForNode, with: ForNode) void {
        const cascading_styles = [_]std.meta.FieldEnum(ForNode){
            .font,
            .fontScale,
            .fontColor,
        };
        inline for (cascading_styles) |sty| {
            const field = std.meta.fieldInfo(ForNode, sty);
            if (eql(field.field_type, @field(self, @tagName(sty)), extras.ptrCastConst(field.field_type, field.default_value.?).*)) {
                @field(self, @tagName(sty)) = @field(with, @tagName(sty));
            }
        }
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

fn eql(comptime T: type, a: T, b: T) bool {
    return switch (@typeInfo(T)) {
        .Int => a == b,
        .Optional => a == b,
        .Pointer => a == b,
        .Struct => a.eql(b),
        else => @compileError("unreachable"),
    };
}
