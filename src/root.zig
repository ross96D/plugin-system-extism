const proto = @import("protobuf");

const std = @import("std");
const testing = std.testing;
const extism = @import("extism");
const c_extism = @import("extism").c;
const sdk = extism;
const Plugin = sdk.Plugin;
const CurrentPlugin = sdk.CurrentPlugin;
const Function = sdk.Function;
const manifest = sdk.manifest;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn hello_from_zig(
    plugin_ptr: ?*c_extism.ExtismCurrentPlugin,
    inputs: [*c]const c_extism.ExtismVal,
    n_inputs: u64,
    outputs: [*c]c_extism.ExtismVal,
    n_outputs: u64,
    user_data: ?*anyopaque,
) callconv(.C) void {
    _ = plugin_ptr;
    _ = inputs;
    _ = n_inputs;
    _ = outputs;
    _ = n_outputs;
    _ = user_data;
}

test "basic add functionality" {
    _ = proto;

    try testing.expect(add(3, 7) == 10);

    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true, .verbose_log = true }){};
    const allocator = gpa.allocator();

    const wasm_file = extism.manifest.WasmFile{ .path = "add.wasm", .name = "add" };

    var ss: i32 = 12;
    const ptr = std.mem.asBytes(&ss);

    const manifest2 = .{ .wasm = &[_]extism.manifest.Wasm{.{ .wasm_file = wasm_file }} };

    const f = extism.Function.init(
        "hello_world",
        &[_]c_extism.ExtismValType{extism.PTR},
        &[_]c_extism.ExtismValType{extism.PTR},
        &hello_from_zig,
        @constCast(@as(*const anyopaque, @ptrCast("user data"))),
    );
    std.debug.print("creating manifest\n", .{});
    var plugin = try extism.Plugin.initFromManifest(
        allocator,
        manifest2,
        &[_]extism.Function{f},
        false,
    );
    std.debug.print("calling plugin\n", .{});

    const v = try plugin.call("add", ptr);

    const val = std.mem.bytesAsValue(i32, v.ptr);

    std.debug.print("result {d}\n", .{val.*});

    // try testing.expect(addPlugin(5) == 10);
}

export fn hello_world(plugin_ptr: ?*sdk.c.ExtismCurrentPlugin, inputs: [*c]const sdk.c.ExtismVal, n_inputs: u64, outputs: [*c]sdk.c.ExtismVal, n_outputs: u64, user_data: ?*anyopaque) callconv(.C) void {
    std.debug.print("Hello from Zig!\n", .{});
    const str_ud = @as([*:0]const u8, @ptrCast(user_data orelse unreachable));
    std.debug.print("User data: {s}\n", .{str_ud});
    var input_slice = inputs[0..n_inputs];
    var output_slice = outputs[0..n_outputs];
    var curr_plugin = CurrentPlugin.getCurrentPlugin(plugin_ptr orelse unreachable);
    const input = curr_plugin.inputBytes(&input_slice[0]);
    std.debug.print("input: {s}\n", .{input});
    output_slice[0] = input_slice[0];
}

const wasmfile_manifest = manifest.WasmFile{ .path = "wasm/code-functions.wasm" };
const man = .{ .wasm = &[_]manifest.Wasm{.{ .wasm_file = wasmfile_manifest }} };

test "Single threaded tests" {
    std.debug.print("calling version\n", .{});
    const version = sdk.extismVersion();
    std.debug.print("version called {s}\n", .{version});
}
