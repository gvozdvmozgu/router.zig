# route-recognizer

High-performance route recognizer for Zig: fast path matching for HTTP routing and URL dispatch.
Supports static segments, params, param suffixes, and catchall segments with escaped literal braces.

Minimum Zig version: 0.15.2

## Install
Add the dependency:
```sh
zig fetch --save git+https://github.com/gvozdvmozgu/zig-router
```

Then wire it into your `build.zig`:
```zig
const router_dep = b.dependency("router", .{});
exe.root_module.addImport("router", router_dep.module("router"));
```

Use it in code:
```zig
const router = @import("router");
```

## Route syntax
- Static: `/about/team`
- Param: `/users/{id}`
- Param with suffix: `/files/{name}.txt`
- Catchall: `/static/{*path}` (must be the final segment)
- Escape literal braces: `{{` and `}}`

## Examples
- `examples/basic_match.zig` (`zig build example:basic`)
- `examples/param_suffix.zig` (`zig build example:param-suffix`)
- `examples/catchall.zig` (`zig build example:catchall`)
- `examples/escaped_braces.zig` (`zig build example:escaped-braces`)

Run one with:
```sh
zig build example:basic
```

## API notes
- `Router(T).insert()` returns `InsertResult` (`.ok` or `.err` with an `InsertError`).
- `Router(T).match()` returns `Match(T)` with owned params; call `deinit()` when done.
- `Match.value` is a pointer to the stored value and is invalidated by insert/remove/merge.
- `Router(T).matchMut()` returns a mutable value pointer with the same lifetime rules.
- `Router(T).remove()` returns `?T` (removed value if present).
- `Router(T).mergeFrom()` moves values from another router and reports conflicts as `MergeResult`.

## Build and test
```sh
zig build test
zig build test:unit
zig build test:fmt
```

## Benchmark
```sh
zig build bench-match -- --routes=900 --paths=9000 --iters=200
```

## Credits

A lot of the code in this package was inspired by [`matchit`](https://github.com/ibraheemdev/matchit).
