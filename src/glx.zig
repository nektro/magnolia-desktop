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

pub const Visual = struct {
    visual: *c.XVisualInfo,

    // zig fmt: off
    var attribs = [_]c.GLint{
        c.GLX_RGBA,
        c.GLX_DOUBLEBUFFER,
        c.GLX_DEPTH_SIZE,     24,
        c.GLX_STENCIL_SIZE,   8,
        c.GLX_RED_SIZE,       8,
        c.GLX_GREEN_SIZE,     8,
        c.GLX_BLUE_SIZE,      8,
        c.GLX_SAMPLE_BUFFERS, 0,
        c.GLX_SAMPLES,        0,
        c.None
    };
    // zig fmt: on

    pub fn init(xdisplay: x.Display) !Visual {
        // TODO: handle C error
        const vis = c.glXChooseVisual(xdisplay.display, xdisplay.screenId, &attribs);
        if (vis == null) return error.TODO;

        return Visual{
            .visual = vis,
        };
    }

    pub fn deinit(self: Visual) void {
        // TODO: investigate possible return values
        _ = c.XFree(self.visual);
    }
};
