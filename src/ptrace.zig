const base = @import("ptrace/base.zig");
const registers = @import("ptrace/registers.zig");

pub const ptrace = base.ptrace;

pub const ptraceFuncs = struct {
    pub const traceme = base.ptrace_traceme;
    pub const attach = base.ptrace_attach;
    pub const dettach = base.ptrace_dettach;
    pub const cont = base.ptrace_continue;

    pub const getRegs = registers.ptrace_getRegs;
    pub const setRegs = registers.ptrace_setRegs;

    pub const getFpRegs = registers.ptrace_getFpRegs;
    pub const setFpRegs = registers.ptrace_setFpRegs;
};
