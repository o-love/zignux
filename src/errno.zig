const std = @import("std");
const linux = std.os.linux;

pub const LinuxError = errorFromErrno(linux.E);

pub fn toLinuxError(value: usize) LinuxError!void {
    switch (linux.E.init(value)) {
        .SUCCESS => return,
        else => |e| {
            const e_value = @intFromEnum(e);

            inline for (@typeInfo(LinuxError).error_set.?) |err| {
                const err_val = @intFromEnum(@field(linux.E, err.name));
                if (err_val == e_value) {
                    return @field(LinuxError, err.name);
                }
            }

            unreachable;
        },
    }
}

fn errorFromErrno(comptime err_enum: type) type {
    const Error = std.builtin.Type.Error;

    const enum_fields = @typeInfo(err_enum).@"enum".fields;

    comptime var errs: []const Error = &.{};
    inline for (enum_fields) |field| {
        if (std.mem.eql(u8, field.name, "SUCCESS")) {
            continue;
        }

        const e = Error{
            .name = field.name,
        };

        errs = errs ++ .{e};
    }

    const e_set = @Type(.{ .error_set = errs[0..] });

    return e_set;
}

test toLinuxError {
    const testing = std.testing;
    const expectError = testing.expectError;

    try toLinuxError(0);

    const err_int: i64 = -1 * @as(i32, @intFromEnum(linux.E.INTR));
    try expectError(
        LinuxError.INTR,
        toLinuxError(@bitCast(err_int)),
    );
}
