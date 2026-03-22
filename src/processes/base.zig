const std = @import("std");
const zignux = @import("../root.zig");

const linux = std.os.linux;
const pid_t = zignux.pid_t;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;


pub fn kill(pid: pid_t, signal: i32) LinuxError!void {
    const result = linux.kill(pid, signal);

    try toLinuxError(result);
}

pub fn fork() LinuxError!pid_t {
    const result = linux.fork();

    try toLinuxError(result);

    return @intCast(result);
}
