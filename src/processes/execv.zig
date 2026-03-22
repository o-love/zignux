const std = @import("std");
const zignux = @import("../root.zig");

const linux = std.os.linux;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;

pub fn execve(
    path: [*:0]const u8,
    argv: [*:null]const ?[*:0]const u8,
    envp: [*:null]const ?[*:0]const u8,
) LinuxError!void {
    const result = linux.execve(path, argv, envp);

    try toLinuxError(result);
}

test "execve fork and wait pipeline" {
    const rerouteStdToNull = @import("../testUtils.zig").rerouteStdToNull;

    const path = "/bin/sh";
    const argv = [_:null]?[*:0]const u8{ "/bin/sh", "-c", "echo hello" };
    const envp = [_:null]?[*:0]const u8{"PATH=/bin"};

    const pid = try zignux.fork();

    if (pid == 0) {
        rerouteStdToNull() catch {
            std.process.exit(1);
        };

        execve(path, &argv, &envp) catch std.process.exit(1);

        unreachable;
    }

    try std.testing.expect(pid > 0);

    _ = try zignux.waitpid(pid, linux.W.UNTRACED);
}
