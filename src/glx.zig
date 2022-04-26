const std = @import("std");

const c = @import("./c.zig");
const x = @import("./x.zig");

pub fn version(xdisplay: x.Display) ?std.SemanticVersion {
    var majorGLX: c_int = 0;
    var minorGLX: c_int = 0;

    // glXQueryVersion returns False if it fails, True otherwise.
    const err = c.glXQueryVersion(xdisplay.display, &majorGLX, &minorGLX);
    if (err == c.False) return null;

    return std.SemanticVersion{
        .major = @intCast(usize, majorGLX),
        .minor = @intCast(usize, minorGLX),
        .patch = 0,
    };
}

pub fn isAtLeast(xdisplay: x.Display, major: usize, minor: usize) bool {
    const input = std.SemanticVersion{ .major = major, .minor = minor, .patch = 0 };
    const vers = version(xdisplay) orelse return false;
    return input.order(vers) != .gt;
}
