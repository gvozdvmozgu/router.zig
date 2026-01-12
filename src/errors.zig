const std = @import("std");

const Allocator = std.mem.Allocator;

/// Errors returned by router match operations.
pub const MatchError = error{NotFound};

/// Errors returned while parsing or normalizing parameter wildcards.
pub const ParamError = error{ InvalidParam, TooManyParams };

/// Owns an allocated string. Call deinit with the allocator that created it.
pub const OwnedStr = struct {
    bytes: []u8,

    /// Free the owned bytes using the original allocator.
    pub fn deinit(self: *OwnedStr, allocator: Allocator) void {
        allocator.free(self.bytes);
    }

    /// Borrow the owned string slice.
    pub fn slice(self: *const OwnedStr) []const u8 {
        return self.bytes;
    }
};

/// Errors reported by insert operations.
pub const InsertError = union(enum) {
    Conflict: OwnedStr,
    InvalidParamSegment,
    InvalidParam,
    TooManyParams,
    InvalidCatchAll,

    /// Free any owned allocations carried by the error.
    pub fn deinit(self: *InsertError, allocator: Allocator) void {
        switch (self.*) {
            .Conflict => |*route| route.deinit(allocator),
            else => {},
        }
    }
};

/// Result of an insert operation.
pub const InsertResult = union(enum) {
    ok,
    err: InsertError,
};

/// Aggregated errors produced during merge operations.
pub const MergeError = struct {
    errors: std.ArrayListUnmanaged(InsertError) = .{},

    /// Free any owned allocations carried by the errors list.
    pub fn deinit(self: *MergeError, allocator: Allocator) void {
        for (self.errors.items) |*err| {
            err.deinit(allocator);
        }
        self.errors.deinit(allocator);
    }
};

/// Result of a merge operation.
pub const MergeResult = union(enum) {
    ok,
    err: MergeError,
};
