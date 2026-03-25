# zignux

An Ergonomic Zig Linux Syscall Library

## Overview

zignux provides Zig-friendly wrappers around Linux syscalls, covering file operations, pipes, processes, ptrace, signals, and more.

## Requirements

- Zig >= 0.15.2
- Linux

## Usage

Add zignux as a dependency in your `build.zig.zon`:

```
zig fetch --save <url>
```

Then in your `build.zig`:

```zig
const zignux = b.dependency("zignux", .{});
exe.root_module.addImport("zignux", zignux.module("zignux"));
```

## License

zlib — see [LICENSE](LICENSE) for details.