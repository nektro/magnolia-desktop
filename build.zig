const std = @import("std");
const string = []const u8;
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    const doall = b.option(bool, "all", "Build all apps, default only selected steps") orelse false;
    const dorun = b.option(bool, "run", "Run the app too") orelse false;
    const strip = b.option(bool, "strip", "Strip debug symbols") orelse false;

    const exes: []const [2]string = &.{
        .{ "triangle", "apps/triangle.zig" },
        .{ "demo-centersquare", "apps/demo-centersquare.zig" },
        .{ "demo-focusblur", "apps/demo-focusblur.zig" },
        .{ "triangle-raw", "apps/triangle-raw.zig" }, // temp for debugging
        .{ "demo-layout", "apps/demo-layout.zig" },
        .{ "demo-layout2", "apps/demo-layout2.zig" },
        .{ "demo-margin", "apps/demo-margin.zig" },
        .{ "demo-text", "apps/demo-text.zig" },
        .{ "demo-centersquare2", "apps/demo-centersquare2.zig" },
        .{ "demo-text2", "apps/demo-text2.zig" },
    };

    inline for (exes) |item| {
        const name = item[0];
        const root_src = item[1];

        const options = b.addOptions();
        options.addOption(string, "name", "magnolia-" ++ name);

        const exe = b.addExecutable("magnolia-" ++ name, root_src);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.addOptions("build_options", options);
        deps.addAllTo(exe);

        if (strip) exe.strip = true;
        const install_step = &b.addInstallArtifact(exe).step;
        if (doall) b.getInstallStep().dependOn(install_step);

        const build_step = b.step(name, "Build the " ++ name ++ " app");
        build_step.dependOn(install_step);

        if (dorun) {
            const run_cmd = exe.run();
            run_cmd.step.dependOn(b.getInstallStep());
            if (b.args) |args| {
                run_cmd.addArgs(args);
            }
            build_step.dependOn(&run_cmd.step);
        }
    }
}
