const std = @import("std");
const string = []const u8;
const deps = @import("./deps.zig");

var doall: bool = false;
var dorun: bool = false;

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    doall = b.option(bool, "all", "Build all apps, default only selected steps") orelse false;
    dorun = b.option(bool, "run", "Run the app too") orelse false;

    addExe(b, target, mode, "triangle", "apps/triangle.zig");
    addExe(b, target, mode, "demo-centersquare", "apps/demo-centersquare.zig");
    addExe(b, target, mode, "demo-focusblur", "apps/demo-focusblur.zig");
    addExe(b, target, mode, "triangle-raw", "apps/triangle-raw.zig"); // temp for debugging
    addExe(b, target, mode, "demo-layout", "apps/demo-layout.zig");
    addExe(b, target, mode, "demo-layout2", "apps/demo/layout2.zig");
}

fn addExe(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode, comptime name: string, root_src: string) void {
    const exe = b.addExecutable("magnolia-" ++ name, root_src);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    deps.addAllTo(exe);

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
