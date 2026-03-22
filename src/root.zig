//! An Ergonomic Linux Syscall Library.

const std = @import("std");

pub const pid_t = std.os.linux.pid_t;

const processesBase = @import("processes/base.zig");

pub const kill = processesBase.kill;
pub const fork = processesBase.fork;

const processesExecv = @import("processes/execv.zig");

pub const execve = processesExecv.execve;

const processesWaitPid = @import("processes/waitPid.zig");

pub const waitpid = processesWaitPid.waitpid;
pub const WaitPidResult = processesWaitPid.WaitPidResult;
pub const WaitPidStatus = processesWaitPid.WaitPidStatus;
pub const WaitPidError = processesWaitPid.WaitPidError;

const errno = @import("errno.zig");

pub const LinuxError = errno.LinuxError;
pub const toLinuxError = errno.toLinuxError;


const files = @import("files.zig");

pub const close = files.close;
pub const openat = files.openat;

const ptraceSrc = @import("ptrace.zig");

pub const ptrace = ptraceSrc.ptrace;
pub const ptraceFuncs = ptraceSrc.ptraceFuncs;

test {
    _ = @import("processes/base.zig");
    _ = @import("processes/execv.zig");
    _ = @import("processes/waitPid.zig");
    _ = @import("ptrace/base.zig");
    _ = @import("ptrace/registers.zig");
    _ = @import("errno.zig");
    _ = @import("errnoMsgs.zig");
    _ = @import("files.zig");
    _ = @import("log.zig");
    _ = @import("pipes.zig");
    _ = @import("ptrace.zig");
    _ = @import("registers.zig");
    _ = @import("testUtils.zig");
}