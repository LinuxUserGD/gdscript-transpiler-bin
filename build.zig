const std = @import("std");
const builtin = std.builtin;
const name = "zig-template";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const bin = b.addExecutable(.{
        .name = name,
        .root_source_file = .{ .path = "zig-template/src/main.zig" },
        .target = target,
        .optimize = builtin.Mode.ReleaseFast,
    });
    bin.rdynamic = true;
    bin.strip = true;
    b.installArtifact(bin);
}

