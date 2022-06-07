//! Parser for Glyph Bitmap Distribution Format font files

// https://en.wikipedia.org/wiki/Glyph_Bitmap_Distribution_Format
// https://adobe-type-tools.github.io/font-tech-notes/pdfs/5005.BDF_Spec.pdf

const std = @import("std");
const string = []const u8;
const log = std.log.scoped(.bdf);
const assert = std.debug.assert;
const max_size = 1024;
const range = @import("range").range;
const extras = @import("extras");

pub const Font = struct {
    xlfd: string,
    pt: u16,
    x_dpi: u16,
    y_dpi: u16,
    w: u8,
    h: u8,
    ll_x: i8,
    ll_y: i8,
    properties: Properties,
    chars: std.AutoHashMapUnmanaged(u16, Char),

    pub fn deinit(self: *Font, alloc: std.mem.Allocator) void {
        alloc.free(self.xlfd);

        {
            var it = self.properties.ints.keyIterator();
            while (it.next()) |s| {
                alloc.free(s.*);
            }
        }
        self.properties.ints.deinit(alloc);
        {
            var it = self.properties.strs.keyIterator();
            while (it.next()) |s| {
                alloc.free(s.*);
            }
        }
        {
            var it = self.properties.strs.valueIterator();
            while (it.next()) |s| {
                alloc.free(s.*);
            }
        }
        self.properties.strs.deinit(alloc);

        {
            var it = self.chars.valueIterator();
            while (it.next()) |c| {
                alloc.free(c.name);
                alloc.free(c.bits);
            }
        }
        self.chars.deinit(alloc);
    }

    pub fn getChar(self: Font, cp: u16) Char {
        return self.chars.get(cp) orelse self.chars.get(0).?;
    }
};

pub const Properties = struct {
    strs: std.StringHashMapUnmanaged(string),
    ints: std.StringHashMapUnmanaged(i16),
};

pub const Char = struct {
    name: string,
    encoding: u16,
    swidthx: u16,
    swidthy: u16,
    dwidthx: u16,
    dwidthy: u16,
    width: u8,
    height: u8,
    ll_x: i8,
    ll_y: i8,
    start: u8,
    bits: []const Set,

    const max_bit_count = 32;
    const Int = std.meta.Int(.unsigned, max_bit_count);
    const Set = std.StaticBitSet(max_bit_count);
};

pub fn parse(alloc: std.mem.Allocator, path: string) !Font {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    var bufread = std.io.bufferedReader(file.reader());
    var counter = std.io.countingReader(bufread.reader());
    log.debug("parsing {s}: {d}", .{ path, (try file.stat()).size });

    const r = counter.reader();

    var font: Font = undefined;

    try assertLine(r, alloc, "STARTFONT 2.1");

    while (true) {
        const keyword = try r.readUntilDelimiterAlloc(alloc, ' ', max_size);
        defer alloc.free(keyword);

        if (std.mem.eql(u8, keyword, "FONT")) {
            font.xlfd = try r.readUntilDelimiterAlloc(alloc, '\n', max_size);
            continue;
        }
        if (std.mem.eql(u8, keyword, "SIZE")) {
            font.pt = try readInt(r, alloc, u16);
            font.x_dpi = try readInt(r, alloc, u16);
            font.y_dpi = try readInt(r, alloc, u16);
            continue;
        }
        if (std.mem.eql(u8, keyword, "FONTBOUNDINGBOX")) {
            font.w = try readInt(r, alloc, u8);
            font.h = try readInt(r, alloc, u8);
            font.ll_x = try readInt(r, alloc, i8);
            font.ll_y = try readInt(r, alloc, i8);
            continue;
        }
        if (std.mem.eql(u8, keyword, "COMMENT")) {
            try skipLine(r, alloc);
            continue;
        }
        if (std.mem.eql(u8, keyword, "STARTPROPERTIES")) {
            const len = try readInt(r, alloc, u8);
            font.properties = try parseProperties(r, alloc, len);
            continue;
        }
        if (std.mem.eql(u8, keyword, "CHARS")) {
            const len = try readInt(r, alloc, u16);
            var chars = std.AutoHashMapUnmanaged(u16, Char){};
            errdefer chars.deinit(alloc);
            for (range(len)) |_| {
                const char = (try parseChar(r, alloc)) orelse continue;
                try chars.putNoClobber(alloc, char.encoding, char);
            }
            font.chars = chars;
            break;
        }

        log.err("TODO keyword: {s}", .{keyword});
        unreachable;
    }

    try assertLine(r, alloc, "ENDFONT");
    return font;
}

fn parseProperties(r: anytype, alloc: std.mem.Allocator, len: u8) !Properties {
    var str_props = std.StringHashMapUnmanaged(string){};
    var int_props = std.StringHashMapUnmanaged(i16){};

    const str_names = [_]string{
        "FOUNDRY",
        "FAMILY_NAME",
        "WEIGHT_NAME",
        "SLANT",
        "SETWIDTH_NAME",
        "ADD_STYLE_NAME",
        "SPACING",
        "CHARSET_REGISTRY",
        "CHARSET_ENCODING",
        "FONTNAME_REGISTRY",
        "FONT_NAME",
        "FACE_NAME",
        "COPYRIGHT",
        "FONT_VERSION",
    };
    const int_names = [_]string{
        "PIXEL_SIZE",
        "POINT_SIZE",
        "RESOLUTION_X",
        "RESOLUTION_Y",
        "AVERAGE_WIDTH",
        "FONT_ASCENT",
        "FONT_DESCENT",
        "UNDERLINE_POSITION",
        "UNDERLINE_THICKNESS",
        "X_HEIGHT",
        "CAP_HEIGHT",
        "DEFAULT_CHAR",
        "RAW_ASCENT",
        "RAW_DESCENT",
        "NORM_SPACE",
        "RELATIVE_WEIGHT",
        "RELATIVE_SETWIDTH",
        "SUPERSCRIPT_X",
        "SUPERSCRIPT_Y",
        "SUPERSCRIPT_SIZE",
        "SUBSCRIPT_X",
        "SUBSCRIPT_Y",
        "SUBSCRIPT_SIZE",
        "FIGURE_WIDTH",
        "AVG_LOWERCASE_WIDTH",
        "AVG_UPPERCASE_WIDTH",
    };

    for (range(len)) |_| {
        const keyword = try r.readUntilDelimiterAlloc(alloc, ' ', max_size);

        if (extras.containsString(&str_names, keyword)) {
            try str_props.putNoClobber(alloc, keyword, try readString(r, alloc));
            continue;
        }
        if (extras.containsString(&int_names, keyword)) {
            try int_props.putNoClobber(alloc, keyword, try readInt(r, alloc, i16));
            continue;
        }

        log.err("TODO properties keyword: {s}", .{keyword});
        unreachable;
    }
    try assertLine(r, alloc, "ENDPROPERTIES");

    return Properties{
        .strs = str_props,
        .ints = int_props,
    };
}

fn parseChar(r: anytype, alloc: std.mem.Allocator) !?Char {
    try assertWord(r, alloc, "STARTCHAR");
    const name = try readWord(r, alloc);
    errdefer alloc.free(name);

    try assertWord(r, alloc, "ENCODING");
    const encoding: ?u16 = readInt(r, alloc, u16) catch |err| switch (err) {
        error.Overflow => null,
        else => |e| return e,
    };

    try assertWord(r, alloc, "SWIDTH");
    const swidthx = try readInt(r, alloc, u16);
    const swidthy = try readInt(r, alloc, u16);

    try assertWord(r, alloc, "DWIDTH");
    const dwidthx = try readInt(r, alloc, u16);
    const dwidthy = try readInt(r, alloc, u16);

    try assertWord(r, alloc, "BBX");
    const w = (try readInt(r, alloc, u8)) + 1;
    const h = try readInt(r, alloc, u8);
    const ll_x = try readInt(r, alloc, i8);
    const ll_y = try readInt(r, alloc, i8);

    try assertLine(r, alloc, "BITMAP");

    var bits = std.ArrayListUnmanaged(Char.Set){};
    errdefer bits.deinit(alloc);
    for (range(h)) |_| {
        const word = try readWord(r, alloc);
        defer alloc.free(word);
        assert(word.len <= 4);
        const pad = try std.fmt.allocPrint(alloc, "{s:0>4}", .{word});
        defer alloc.free(pad);
        const int = try std.fmt.parseUnsigned(Char.Int, pad, 16);
        const set = Char.Set{ .mask = int };
        try bits.append(alloc, set);
    }

    var start: usize = Char.max_bit_count;
    for (bits.items) |set| {
        start = std.math.min(start, set.findFirstSet() orelse continue);
    }
    if (start == Char.max_bit_count) start = 0;
    try assertLine(r, alloc, "ENDCHAR");

    if (encoding == null) {
        alloc.free(name);
        bits.deinit(alloc);
        return null;
    }
    // TODO make this use .{
    // error: expected type 'std.meta.struct:1069:19', found '.magnolia.bdf.struct:216:41'
    return extras.positionalInit(Char, extras.FieldsTuple(Char){ name, encoding.?, swidthx, swidthy, dwidthx, dwidthy, w, h, ll_x, ll_y, @intCast(u8, start), bits.toOwnedSlice(alloc) });
}

//

fn assertLine(reader: anytype, alloc: std.mem.Allocator, expected: string) !void {
    const actual = try reader.readUntilDelimiterAlloc(alloc, '\n', expected.len + 1);
    defer alloc.free(actual);
    assert(std.mem.eql(u8, actual, expected));
}

fn readUntilDelimiterAlloc(reader: anytype, alloc: std.mem.Allocator, haystack: []const u8) ![]u8 {
    var array_list = std.ArrayList(u8).init(alloc);
    errdefer array_list.deinit();
    array_list.shrinkRetainingCapacity(0);
    while (true) {
        if (array_list.items.len == max_size) {
            return error.StreamTooLong;
        }
        var byte: u8 = try reader.readByte();
        if (std.mem.indexOfScalar(u8, haystack, byte)) |_| break;
        try array_list.append(byte);
    }
    return array_list.toOwnedSlice();
}

fn readWord(reader: anytype, alloc: std.mem.Allocator) !string {
    return try readUntilDelimiterAlloc(reader, alloc, " \n");
}

fn readInt(reader: anytype, alloc: std.mem.Allocator, comptime T: type) !T {
    const w = try readWord(reader, alloc);
    defer alloc.free(w);
    return std.fmt.parseInt(T, w, 10);
}

fn skipLine(reader: anytype, alloc: std.mem.Allocator) !void {
    alloc.free(try reader.readUntilDelimiterAlloc(alloc, '\n', max_size));
}

fn readString(reader: anytype, alloc: std.mem.Allocator) !string {
    assert((try reader.readByte()) == '"');
    const str = try readUntilDelimiterAlloc(reader, alloc, "\"");
    {
        const w = try readWord(reader, alloc);
        defer alloc.free(w);
        assert(w.len == 0);
    }
    return str;
}

fn assertWord(reader: anytype, alloc: std.mem.Allocator, expected: string) !void {
    const actual = try readWord(reader, alloc);
    defer alloc.free(actual);
    assert(std.mem.eql(u8, actual, expected));
}
