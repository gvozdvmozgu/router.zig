//! High-performance route recognizer for Zig.
//!
//! Supports static segments (`/about`), params (`/users/{id}`), param suffixes
//! (`/files/{name}.txt`), and catchall segments (`/static/{*path}`), with
//! escaped literal braces via `{{` and `}}`.
//!
//! Typical usage:
//! ```zig
//! const router = @import("router");
//! var r = router.Router(u32).init(allocator);
//! defer r.deinit();
//!
//! _ = try r.insert("/users/{id}", 42);
//! const match = try r.match("/users/7");
//! defer match.deinit();
//! ```
const errors = @import("errors.zig");
const params = @import("params.zig");
const router = @import("router.zig");

/// Errors returned by match operations.
pub const MatchError = errors.MatchError;
/// Owned string used in error reporting.
pub const OwnedStr = errors.OwnedStr;
/// Errors reported by insert operations.
pub const InsertError = errors.InsertError;
/// Result of an insert operation.
pub const InsertResult = errors.InsertResult;
/// Aggregated errors produced during merge operations.
pub const MergeError = errors.MergeError;
/// Result of a merge operation.
pub const MergeResult = errors.MergeResult;

/// Single route parameter key/value pair.
pub const Param = params.Param;
/// Compact parameter list container.
pub const Params = params.Params;
/// Public key/value view used by ParamsIter.
pub const ParamKV = params.ParamKV;
/// Iterator over Params.
pub const ParamsIter = params.ParamsIter;

/// Match result with an immutable value pointer.
pub const Match = router.Match;
/// Match result with a mutable value pointer.
pub const MatchMut = router.MatchMut;
/// Route matcher storing values of type T.
pub const Router = router.Router;
