const std = @import("std");
const builtin = @import("builtin");
const native_arch = builtin.cpu.arch;

pub const dwarf_id_t = i32;

pub const UserFpRegs = switch (native_arch) {
    .x86_64 => x64_UserFpRegs,
    else => @compileError("Zignux unsupported register architecture"),
};

pub const UserRegs = switch (native_arch) {
    .x86_64 => x64_UserRegs,
    else => @compileError("Zignux unsupported register architecture"),
};

const x64_UserFpRegs = extern struct {
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


const x64_UserRegsDefinition = [_]RegisterCompilerDefinition{
    x64GPR_64("orig_rax", -1),
    // rax
    x64GPR_64("rax", 0),
    x64GPR_32("eax", "rax"),
    x64GPR_16("ax", "rax"),
    x64GPR_8H("ah", "rax"),
    x64GPR_8L("al", "rax"),
    // rdx
    x64GPR_64("rdx", 1),
    x64GPR_32("edx", "rdx"),
    x64GPR_16("dx", "rdx"),
    x64GPR_8H("dh", "rdx"),
    x64GPR_8L("dl", "rdx"),
    // rcx
    x64GPR_64("rcx", 2),
    x64GPR_32("ecx", "rcx"),
    x64GPR_16("cx", "rcx"),
    x64GPR_8H("ch", "rcx"),
    x64GPR_8L("cl", "rcx"),
    // rbx
    x64GPR_64("rbx", 3),
    x64GPR_32("ebx", "rbx"),
    x64GPR_16("bx", "rbx"),
    x64GPR_8H("bh", "rbx"),
    x64GPR_8L("bl", "rbx"),
    // rsi
    x64GPR_64("rsi", 4),
    x64GPR_32("esi", "rsi"),
    x64GPR_16("si", "rsi"),
    x64GPR_8L("sil", "rsi"),
    // rdi
    x64GPR_64("rdi", 5),
    x64GPR_32("edi", "rdi"),
    x64GPR_16("di", "rdi"),
    x64GPR_8L("dil", "rdi"),
    // rbp
    x64GPR_64("rbp", 6),
    x64GPR_32("ebp", "rbp"),
    x64GPR_16("bp", "rbp"),
    x64GPR_8L("bpl", "rbp"),
    // rsp
    x64GPR_64("rsp", 7),
    x64GPR_32("esp", "rsp"),
    x64GPR_16("sp", "rsp"),
    x64GPR_8L("spl", "rsp"),
    // r8
    x64GPR_64("r8", 8),
    x64GPR_32("r8d", "r8"),
    x64GPR_16("r8w", "r8"),
    x64GPR_8L("r8b", "r8"),
    // r9
    x64GPR_64("r9", 9),
    x64GPR_32("r9d", "r9"),
    x64GPR_16("r9w", "r9"),
    x64GPR_8L("r9b", "r9"),
    // r10
    x64GPR_64("r10", 10),
    x64GPR_32("r10d", "r10"),
    x64GPR_16("r10w", "r10"),
    x64GPR_8L("r10b", "r10"),
    // r11
    x64GPR_64("r11", 11),
    x64GPR_32("r11d", "r11"),
    x64GPR_16("r11w", "r11"),
    x64GPR_8L("r11b", "r11"),
    // r12
    x64GPR_64("r12", 12),
    x64GPR_32("r12d", "r12"),
    x64GPR_16("r12w", "r12"),
    x64GPR_8L("r12b", "r12"),
    // r13
    x64GPR_64("r13", 13),
    x64GPR_32("r13d", "r13"),
    x64GPR_16("r13w", "r13"),
    x64GPR_8L("r13b", "r13"),
    // r14
    x64GPR_64("r14", 14),
    x64GPR_32("r14d", "r14"),
    x64GPR_16("r14w", "r14"),
    x64GPR_8L("r14b", "r14"),
    // r15
    x64GPR_64("r15", 15),
    x64GPR_32("r15d", "r15"),
    x64GPR_16("r15w", "r15"),
    x64GPR_8L("r15b", "r15"),
    // rip
    x64GPR_64("rip", 16),
    // eflags
    x64GPR_64("eflagfs", 49),
    // es
    x64GPR_64("es", 50),
    // cs
    x64GPR_64("cs", 51),
    // ss
    x64GPR_64("ss", 52),
    // ds
    x64GPR_64("ds", 53),
    // fs
    x64GPR_64("fs", 54),
    // gs
    x64GPR_64("gs", 55),
};

comptime {
    if (x64_UserRegsDefinition.len == 0) {
        @compileError("x64_UserRegsDefinition should not be empty");
    }
}

fn x64GPR_64(name: []const u8, dwarf_id: dwarf_id_t) RegisterCompilerDefinition {
    return RegisterCompilerDefinition{
        .name = name,
        .super = name,
        .dwarf_id = dwarf_id,
        .unit = u64,
        .r_type = .General,
        .format = .Uint,
    };
}

fn x64GPR_32(name: []const u8, parent: []const u8) RegisterCompilerDefinition {
    return RegisterCompilerDefinition{
        .name = name,
        .super = parent,
        .dwarf_id = -1,
        .unit = u32,
        .r_type = .SubGeneral,
        .format = .Uint,
    };
}

fn x64GPR_16(name: []const u8, parent: []const u8) RegisterCompilerDefinition {
    return RegisterCompilerDefinition{
        .name = name,
        .super = parent,
        .dwarf_id = -1,
        .unit = u16,
        .r_type = .SubGeneral,
        .format = .Uint,
    };
}

fn x64GPR_8H(name: []const u8, parent: []const u8) RegisterCompilerDefinition {
    // TODO: Increase offset of 8H by 1 byte

    return RegisterCompilerDefinition{
        .name = name,
        .super = parent,
        .dwarf_id = -1,
        .unit = u8,
        .r_type = .SubGeneral,
        .format = .Uint,
    };
}

fn x64GPR_8L(name: []const u8, parent: []const u8) RegisterCompilerDefinition {
    return RegisterCompilerDefinition{
        .name = name,
        .super = parent,
        .dwarf_id = -1,
        .unit = u8,
        .r_type = .SubGeneral,
        .format = .Uint,
    };
}



const x64_UserRegs = extern struct {
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

pub const RegisterType = enum {
    General,
    SubGeneral,
    Float,
    Debug,
};

pub const RegisterFormat = enum {
    Uint,
    DoubleFloat,
    LongDouble,
    Vector,
};

pub const RegisterCompilerDefinition = struct {
    name: []const u8,
    super: []const u8,
    dwarf_id: dwarf_id_t,
    unit: type,
    r_type: RegisterType,
    format: RegisterFormat,
};
