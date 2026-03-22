const std = @import("std");
const zignux = @import("../root.zig");

const linux = std.os.linux;
const PTRACE_FLAGS = linux.PTRACE;
const pid_t = zignux.pid_t;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;

const msgs = @import("../errnoMsgs.zig");

pub fn ptrace(
    req: u32,
    pid: pid_t,
    addr: usize,
    data: usize,
    addr2: usize,
) LinuxError!void {
    const result = linux.ptrace(req, pid, addr, data, addr2);

    toLinuxError(result) catch |err| switch (err) {
        LinuxError.FAULT => std.debug.panic(msgs.efault_msg, .{}),
        LinuxError.INVAL => std.debug.panic(msgs.einval_msg, .{}),
        else => |e| return e,
    };
}

pub fn ptrace_traceme() LinuxError!void {
    return ptrace(
        PTRACE_FLAGS.TRACEME,
        0,
        0,
        0,
        0,
    );
}

pub fn ptrace_attach(pid: pid_t) LinuxError!void {
    return ptrace(
        PTRACE_FLAGS.ATTACH,
        pid,
        0,
        0,
        0,
    );
}

pub fn ptrace_dettach(pid: pid_t) LinuxError!void {
    return ptrace(
        PTRACE_FLAGS.DETACH,
        pid,
        0,
        0,
        0,
    );
}

pub fn ptrace_continue(pid: pid_t) LinuxError!void {
    return ptrace(
        PTRACE_FLAGS.CONT,
        pid,
        0,
        0,
        0,
    );
}
