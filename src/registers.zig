const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

pub const UserFpRegs = switch (native_arch) {
    .x86_64 => x86_64_UserFpRegs,
    else => @compileError("Zignux unsupported register architecture"),
};

pub const UserRegs = switch (native_arch) {
    .x86_64 => x86_64_UserRegs,
    else => @compileError("Zignux unsupported register architecture"),
};


const x86_64_UserFpRegs = extern struct {
    cwd: u16,
    swd: u16,
    ftw: u16,
    fop: u16,
    rip: u64,
    rdp: u64,
    mxcsr: u32,
    mxcr_mask: u32,
    st_space: [32]u32,
    xmm_space: [64]u32,
    padding: [24]u32,
};

const x86_64_UserRegs = extern struct {
    r15: u64,
    r14: u64,
    r13: u64,
    r12: u64,
    rbp: u64,
    rbx: u64,
    r11: u64,
    r10: u64,
    r9: u64,
    r8: u64,
    rax: u64,
    rcx: u64,
    rdx: u64,
    rsi: u64,
    rdi: u64,
    orig_rax: u64,
    rip: u64,
    cs: u64,
    eflags: u64,
    rsp: u64,
    ss: u64,
    fs_base: u64,
    gs_base: u64,
    ds: u64,
    es: u64,
    fs: u64,
    gs: u64,
};
