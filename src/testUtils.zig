const std = @import("std");
const zignux = @import("root.zig");

const linux = std.os.linux;

pub fn rerouteStdToNull() !void {
    const devnull: i32 = try zignux.openat(linux.AT.FDCWD, "/dev/null", .{ .ACCMODE = .RDWR }, 0);
    _ = linux.dup2(devnull, 1);
    _ = linux.dup2(devnull, 2);
    _ = linux.close(devnull);
}
