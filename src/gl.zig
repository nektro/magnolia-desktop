const std = @import("std");
const string = []const u8;
const extras = @import("extras");

const c = @import("./c.zig");
const x11 = @import("./x11.zig");

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

fn color4(r: f32, g: f32, b: f32, a: f32) void {
    c.glColor4f(r, g, b, a);
}

pub fn color3(r: f32, g: f32, b: f32) void {
    return color4(r, g, b, 1);
}

fn vertex2(x: u32, y: u32) void {
    c.glVertex3i(@intCast(c_int, x), @intCast(c_int, y), 0);
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

pub const Point = struct {
    x: u32,
    y: u32,
};

pub const Path = struct {
    items: []const Item,

    pub const Item = union(enum) {
        vertexc: std.meta.Tuple(&.{ Point, Color }),
        vertexp: std.meta.Tuple(&.{Point}),
    };
};

fn drawRaw(mode: consts.Primitive, items: []const Path.Item) void {
    c.glBegin(@enumToInt(mode));

    for (items) |it| {
        switch (it) {
            .vertexc => |v| {
                color3(v[1].r, v[1].g, v[1].b);
                vertex2(v[0].x, v[0].y);
            },
            .vertexp => |v| {
                vertex2(v[0].x, v[0].y);
            },
        }
    }
    c.glEnd();
}

pub fn draw(items: []const Path.Item) void {
    return drawRaw(.POLYGON, items);
}

pub fn vertexc(x: u32, y: u32, r: f32, g: f32, b: f32) Path.Item {
    return Path.Item{ .vertexc = .{
        .{ .x = x, .y = y },
        .{ .r = r, .g = g, .b = b },
    } };
}

pub fn vertexp(x: u32, y: u32) Path.Item {
    return Path.Item{ .vertexp = .{
        .{ .x = x, .y = y },
    } };
}

pub fn commitFrame(xwindow: x11.Window) void {
    c.glXSwapBuffers(xwindow.display, xwindow.window);
}

pub fn drawPoints(items: []const Path.Item) void {
    return drawRaw(.POINTS, items);
}
