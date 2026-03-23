//! An Ergonomic Linux Syscall Library.

const std = @import("std");

pub const pid_t = std.os.linux.pid_t;
pub const SIGNAL = std.os.linux.SIG;

const processesBaseSrc = @import("processes/base.zig");

pub const kill = processesBaseSrc.kill;
pub const fork = processesBaseSrc.fork;

const processesExecvSrc = @import("processes/execv.zig");

pub const execve = processesExecvSrc.execve;

const processesWaitPidSrc = @import("processes/waitpid.zig");

pub const waitpid = processesWaitPidSrc.waitpid;
pub const WaitPidResult = processesWaitPidSrc.WaitPidResult;
pub const WaitPidStatus = processesWaitPidSrc.WaitPidStatus;
pub const WaitPidError = processesWaitPidSrc.WaitPidError;

const errnoSrc = @import("errno.zig");

pub const LinuxError = errnoSrc.LinuxError;
pub const toLinuxError = errnoSrc.toLinuxError;

const filesSrc = @import("files.zig");

pub const close = filesSrc.close;
pub const openat = filesSrc.openat;

const pipesSrc = @import("pipes.zig");

pub const pipe = pipesSrc.pipe;
pub const PipeResult = pipesSrc.PipeResult;

const ptraceSrc = @import("ptrace.zig");

pub const ptraceFuncs = ptraceSrc.ptraceFuncs;

test {
    _ = @import("processes/base.zig");
    _ = @import("processes/execv.zig");
    _ = @import("processes/waitpid.zig");
    _ = @import("ptrace/base.zig");
    _ = @import("ptrace/registers.zig");
    _ = @import("errno.zig");
    _ = @import("msgs.zig");
    _ = @import("files.zig");
    _ = @import("log.zig");
    _ = @import("pipes.zig");
    _ = @import("ptrace.zig");
    _ = @import("registers.zig");
    _ = @import("test_utils.zig");
}