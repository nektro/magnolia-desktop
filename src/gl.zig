const std = @import("std");
const string = []const u8;
const extras = @import("extras");

const c = @import("./c.zig");
const x = @import("./x.zig");

pub const consts = @import("./gl.consts.zig");

pub const String = enum(c_uint) {
    vendor = @enumToInt(consts.Utility.VENDOR),
    renderer = @enumToInt(consts.Utility.RENDERER),
    version = @enumToInt(consts.Utility.VERSION),
    extensions = @enumToInt(consts.Utility.EXTENSIONS),
    // shading_language_version = 0x8B8C, // added in gl 2.0

    pub fn get(self: String) string {
        return std.mem.span(c.glGetString(@enumToInt(self)));
    }

    pub fn extensionCount() usize {
        return extras.countScalar(u8, String.extensions.get(), ' ');
    }
};

pub const Color = struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32 = 1,
};

pub fn color4(r: f32, g: f32, b: f32, a: f32) void {
    c.glColor4f(r, g, b, a);
}

pub fn color3(r: f32, g: f32, b: f32) void {
    return color4(r, g, b, 1);
}

pub fn vertex2(px: f32, py: f32) void {
    c.glVertex3f(px, py, 0);
}

pub fn clear(
    buffer: enum(c_uint) {
        color = @enumToInt(consts.PushPopAttribBit.COLOR_BUFFER_BIT),
        depth = @enumToInt(consts.PushPopAttribBit.DEPTH_BUFFER_BIT),
        stencil = @enumToInt(consts.PushPopAttribBit.STENCIL_BUFFER_BIT),
    },
) void {
    c.glClear(@enumToInt(buffer));
}
