const std = @import("std");
const string = []const u8;
const deps = @import("./deps.zig");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    addExe(b, target, mode, "triangle", "apps/triangle.zig");
    addExe(b, target, mode, "demo-centersquare", "apps/demo-centersquare.zig");
    addExe(b, target, mode, "demo-focusblur", "apps/demo-focusblur.zig");
    addExe(b, target, mode, "triangle-raw", "apps/triangle-raw.zig"); // temp for debugging
}

fn addExe(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode, comptime name: string, root_src: string) void {
    const exe = b.addExecutable("magnolia-" ++ name, root_src);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    deps.addAllTo(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    // if (b.args) |args| {
    //     run_cmd.addArgs(args);
    // }

    const run_step = b.step(name, "Run the " ++ name ++ "app");
    run_step.dependOn(&run_cmd.step);
}

// https://materialui.co/flatuicolors
//

// hi mommy :) u r doing such a good job!!!!
