const std = @import("std");
const zignux = @import("root.zig");

const linux = std.os.linux;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;

pub fn close(fd: i32) LinuxError!void {
    const result = linux.close(fd);

    try toLinuxError(result);
}

pub fn openat(dirfd: i32, path: [*:0]const u8, flags: linux.O, mode: linux.mode_t) LinuxError!i32 {
    const fd_result = linux.openat(dirfd, path, flags, mode);

    try toLinuxError(fd_result);

    return @intCast(fd_result);
}
