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
