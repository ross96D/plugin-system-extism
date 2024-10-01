const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    comptime {
        const current_zig = builtin.zig_version;
        const min_zig = std.SemanticVersion.parse("0.12.0-dev.2030") catch unreachable; // build system changes: ziglang/zig#18160
        if (current_zig.order(min_zig) == .lt) {
            @compileError(std.fmt.comptimePrint("Your Zig version v{} does not meet the minimum build requirement of v{}", .{ current_zig, min_zig }));
        }
    }

    const extism_module = b.addModule("extism", .{
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "src/main.zig" } },
        .target = target,
        .optimize = optimize,
    });

    extism_module.linkSystemLibrary("extism", .{ .needed = true });
    extism_module.link_libc = true;

    tests(b, extism_module, target, optimize);
    examples(b, extism_module, target, optimize);
}

fn tests(
    b: *std.Build,
    extism_module: *std.Build.Module,
    target: ?std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    var t = b.addTest(.{
        .name = "Library Tests",
        .root_source_file = .{ .src_path = .{ .owner = b, .sub_path = "test.zig" } },
        .target = target,
        .optimize = optimize,
    });

    t.root_module.addImport("extism", extism_module);
    // t.linkLibC();
    // t.addIncludePath(.{ .src_path = .{ .owner = b, .sub_path = "/usr/local/include" } });
    // t.addLibraryPath(.{ .src_path = .{ .owner = b, .sub_path = "/usr/local/lib" } });
    // t.linkSystemLibrary("extism");
    const tests_run_step = b.addRunArtifact(t);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests_run_step.step);
}

fn examples(
    b: *std.Build,
    extism_module: *std.Build.Module,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    var example = b.addExecutable(.{
        .name = "Example",
        .root_source_file = .{ .cwd_relative = "examples/basic.zig" },
        .target = target,
        .optimize = optimize,
    });

    example.root_module.addImport("extism", extism_module);
    // example.linkLibC();
    // example.addIncludePath(.{ .path = "/usr/local/include" });
    // example.addLibraryPath(.{ .path = "/usr/local/lib" });
    // example.linkSystemLibrary("extism");
    const example_run_step = b.addRunArtifact(example);

    const example_step = b.step("run_example", "Run the basic example");
    example_step.dependOn(&example_run_step.step);
}
