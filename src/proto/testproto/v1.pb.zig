// Code generated by protoc-gen-zig
///! package testproto.v1
const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const protobuf = @import("protobuf");
const ManagedString = protobuf.ManagedString;
const fd = protobuf.fd;

pub const METHOD = enum(i32) {
    METHOD_UNSPECIFIED = 0,
    METHOD_GET = 1,
    METHOD_POST = 2,
    METHOD_PUT = 3,
    METHOD_DELETE = 4,
    METHOD_OPTION = 5,
    METHOD_CONNECT = 6,
    METHOD_TRACE = 7,
    METHOD_PATCH = 8,
    METHOD_HEAD = 9,
    _,
};

pub const Request = struct {
    method: METHOD = @enumFromInt(0),
    headers: ArrayList(HeadersEntry),
    url: ManagedString = .Empty,
    body: ManagedString = .Empty,

    pub const _desc_table = .{
        .method = fd(1, .{ .Varint = .Simple }),
        .headers = fd(2, .{ .List = .{ .SubMessage = {} } }),
        .url = fd(3, .String),
        .body = fd(4, .Bytes),
    };

    pub const HeadersEntry = struct {
        key: ManagedString = .Empty,
        value: ManagedString = .Empty,

        pub const _desc_table = .{
            .key = fd(1, .String),
            .value = fd(2, .String),
        };

        pub usingnamespace protobuf.MessageMixins(@This());
    };

    pub usingnamespace protobuf.MessageMixins(@This());
};

pub const Response = struct {
    status: u32 = 0,
    headers: ArrayList(HeadersEntry),
    body: ManagedString = .Empty,

    pub const _desc_table = .{
        .status = fd(1, .{ .Varint = .Simple }),
        .headers = fd(2, .{ .List = .{ .SubMessage = {} } }),
        .body = fd(3, .Bytes),
    };

    pub const HeadersEntry = struct {
        key: ManagedString = .Empty,
        value: ManagedString = .Empty,

        pub const _desc_table = .{
            .key = fd(1, .String),
            .value = fd(2, .String),
        };

        pub usingnamespace protobuf.MessageMixins(@This());
    };

    pub usingnamespace protobuf.MessageMixins(@This());
};

pub const EncryptedPassword = struct {
    name: ManagedString = .Empty,
    encrypted: ManagedString = .Empty,

    pub const _desc_table = .{
        .name = fd(1, .String),
        .encrypted = fd(2, .String),
    };

    pub usingnamespace protobuf.MessageMixins(@This());
};
