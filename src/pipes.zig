const std = @import("std");
const zignux = @import("root.zig");

const linux = std.os.linux;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;
const fork = zignux.fork;
const close = zignux.close;

pub const PipeResult = struct {
    reader: i32,
    writer: i32,
};

pub fn pipe() LinuxError!PipeResult {
    const pipe2 = linux.pipe2;

    var pipefd: [2]i32 = undefined;
    const result = pipe2(&pipefd, .{ .CLOEXEC = true });

    try toLinuxError(result);

    return .{
        .reader = pipefd[0],
        .writer = pipefd[1],
    };
}

test pipe {
    const testing = std.testing;
    const rerouteStdToNull = @import("testUtils.zig").rerouteStdToNull;

    const printString = "Hey, how are you";

    const pipes = try pipe();
    const pid = try fork();

    if (pid == 0) {
        try close(pipes.reader);
        rerouteStdToNull() catch {
            std.process.exit(1);
        };

        const file = std.fs.File{ .handle = pipes.writer };

        var buffer: [1024]u8 = undefined;

        var writer = file.writer(&buffer);
        try writer.interface.writeAll(printString);
        try writer.interface.flush();

        file.close();

        linux.exit(0);
    }

    try close(pipes.writer);
    _ = try zignux.waitpid(pid, 0);

    const file = std.fs.File{ .handle = pipes.reader };

    var buffer: [1024]u8 = undefined;

    var reader = file.reader(&buffer);

    var readBuffer: [1024]u8 = undefined;
    const len = try reader.interface.readSliceShort(&readBuffer);
    const resultString = readBuffer[0..len];

    try testing.expectEqualStrings(resultString, printString);
}

