const std = @import("std");
const zignux = @import("root.zig");

const linux = std.os.linux;
const LinuxError = zignux.LinuxError;
const toLinuxError = zignux.toLinuxError;
const fork = zignux.fork;
const close = zignux.close;
const File = std.fs.File;

pub const PipeResult = struct {
    reader: File,
    writer: File,
};

pub fn pipe() LinuxError!PipeResult {
    const pipe2 = linux.pipe2;

    var pipefd: [2]i32 = undefined;
    const result = pipe2(&pipefd, .{ .CLOEXEC = true });

    try toLinuxError(result);

    return .{
        .reader = File{ .handle = pipefd[0] },
        .writer = File{ .handle = pipefd[1] },
    };
}

test "pipe across fork" {
    const testing = std.testing;
    const rerouteStdToNull = @import("test_utils.zig").rerouteStdToNull;

    const printString = "Hey, how are you";

    const pipes = try pipe();
    const pid = try fork();

    if (pid == 0) {
        pipes.reader.close();

        rerouteStdToNull() catch {
            std.process.exit(1);
        };

        const file = pipes.writer;

        var buffer: [1024]u8 = undefined;

        var writer = file.writer(&buffer);
        try writer.interface.writeAll(printString);
        try writer.interface.flush();

        file.close();

        linux.exit(0);
    }

    pipes.writer.close();
    _ = try zignux.waitpid(pid, 0);

    const file = pipes.reader;
    defer file.close();

    var buffer: [1024]u8 = undefined;

    var reader = file.reader(&buffer);

    var readBuffer: [1024]u8 = undefined;
    const len = try reader.interface.readSliceShort(&readBuffer);
    const resultString = readBuffer[0..len];

    try testing.expectEqualStrings(resultString, printString);
}
