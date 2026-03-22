
const base = @import("ptrace/base.zig");

pub const ptrace = base.ptrace;

pub const ptraceFuncs = struct {
    pub const traceme = base.ptrace_traceme;
    pub const attach = base.ptrace_attach;
    pub const dettach = base.ptrace_dettach;
    pub const cont = base.ptrace_continue;
};