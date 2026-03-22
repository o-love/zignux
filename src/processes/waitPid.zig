const std = @import("std");
const zignux = @import("../root.zig");

const linux = std.os.linux;
const pid_t = zignux.pid_t;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;

const log = @import("../log.zig");
const msgs = @import("../errnoMsgs.zig");

pub const WaitPidResult = struct {
    pid: pid_t,
    status: WaitPidStatus,
};

pub const WaitPidStatus = union(enum) {
    Exited: struct { exit_status: u8 },
    Signaled: struct { signal: u32 },
    Stopped: struct { signal: u32 },
    Continued,
};

pub const WaitPidError = error{
InvalidStatus,
} || LinuxError;

fn mapWaitPid(status: u32) WaitPidError!WaitPidStatus {
    const W = linux.W;

    if (W.IFEXITED(status)) {
        return WaitPidStatus{ .Exited = .{
            .exit_status = W.EXITSTATUS(status),
        } };
    } else if (W.IFSIGNALED(status)) {
        return WaitPidStatus{ .Signaled = .{
            .signal = W.TERMSIG(status),
        } };
    } else if (W.IFSTOPPED(status)) {
        return WaitPidStatus{ .Stopped = .{
            .signal = W.STOPSIG(status),
        } };
    }

    log.err("Unable to parse waitpid status {}", .{status});
    return WaitPidError.InvalidStatus;
}

test mapWaitPid {
    const testing = std.testing;
    const expectEqual = testing.expectEqual;

    const res = try mapWaitPid(0);
    try expectEqual(WaitPidStatus{ .Exited = .{ .exit_status = 0 } }, res);
}

pub fn waitpid(pid: pid_t, flags: u32) WaitPidError!WaitPidResult {
    var status: u32 = undefined;

    while (true) {
        const result = linux.waitpid(pid, &status, flags);

        toLinuxError(result) catch |err| switch (err) {
            LinuxError.INTR => continue,
            LinuxError.INVAL => std.debug.panic(msgs.einval_msg, .{}),
            else => return err,
        };

        return .{
            .pid = @intCast(result),
            .status = try mapWaitPid(status),
        };
    }
}
