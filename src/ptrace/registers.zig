const std = @import("std");
const zignux = @import("../root.zig");

const linux = std.os.linux;
const PTRACE_FLAGS = linux.PTRACE;

const pid_t = zignux.pid_t;
const ptrace = zignux.ptrace;
const UserRegs = zignux.UserRegs;
const UsereFpRegs = zignux.UserFpRegs;
const LinuxError = zignux.LinuxError;

pub fn ptrace_getRegs(pid: pid_t) LinuxError!UserRegs {
    var regs: UserRegs = .{};

    try ptrace(
        PTRACE_FLAGS.GETREGS,
        pid,
        0,
        @intFromPtr(&regs),
        0,
    );

    return regs;
}

pub fn ptrace_setRegs(pid: pid_t, regs: UserRegs) LinuxError!void {
    return ptrace(
        PTRACE_FLAGS.SETREGS,
        pid,
        0,
        @intFromPtr(&regs),
        0,
    );
}

pub fn ptrace_getFpRegs(pid: pid_t) LinuxError!UsereFpRegs {
    var regs: UsereFpRegs = .{};

    try ptrace(
        PTRACE_FLAGS.GETFPREGS,
        pid,
        0,
        @intFromPtr(&regs),
        0,
    );

    return regs;
}

pub fn ptrace_setFpRegs(pid: pid_t, regs: UsereFpRegs) LinuxError!void {
    return ptrace(
        PTRACE_FLAGS.SETFPREGS,
        pid,
        0,
        @intFromPtr(&regs),
        0,
    );
}
