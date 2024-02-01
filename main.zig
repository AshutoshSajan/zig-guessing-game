const std = @import("std");
const expect = std.testing.expect;

pub fn nextLine(reader: anytype, buffer: []u8) !?[]const u8 {
    var line = (try reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    )) orelse return null;

    // ignore window specific char
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(
            u8,
            line,
            "\r",
        );
    } else {
        return line;
    }
}

pub fn guessNumber() !bool {
    const stdout = std.io.getStdOut();
    const stdin = std.io.getStdIn();
    const magic_number: u8 = 7;

    try stdout.writeAll(
        \\Guess a number:
    );

    var buffer: [100]u8 = undefined;
    const input = (try nextLine(stdin.reader(), &buffer)).?;

    const num = try std.fmt.parseInt(u8, input, 10);

    var guess = if (num == magic_number) "rigth" else "wrong";

    try stdout.writer().print(
        "Your guess is {s}\n",
        .{guess},
    );

    return num == magic_number;
}

pub fn game() !void {
    var maxAttempts: u8 = 3;
    var count: u8 = 0;

    while (count < maxAttempts) {
        const guess = guessNumber() catch |err| {
            std.debug.print("Invalid input! Error: '{}'\n", .{err});
            break;
        };

        if (guess == true) {
            break;
        }

        count += 1;
    }

    if (count >= maxAttempts) {
        std.debug.print("max attempt reached\n", .{});
    }
}

pub fn main() !void {
    try game();
}
