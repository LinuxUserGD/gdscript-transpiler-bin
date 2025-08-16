const std = @import("std");
const builtin = std.builtin;
const name = "zig-template";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});
    const bin = b.addExecutable(.{
        .name = name,
        .root_module = b.createModule(.{
            .root_source_file = b.path("zig-template/src/main.zig"),
            .optimize = mode,
            .target = target,
            .strip = true,
        }),
        .use_llvm = true,
        .use_lld = true,
    });
    bin.rdynamic = false;
    b.installArtifact(bin);
}

