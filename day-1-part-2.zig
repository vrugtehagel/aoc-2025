const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-1/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(6858, answer);
}
pub fn solution(input: []const u8) !i32 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var position: i32 = 50;
    var zeroes: i32 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const direction = line[0];
        const sign: i2 = if (direction == 'R') 1 else -1;
        const amount = try std.fmt.parseInt(i32, line[1..], 10);
        if (sign == -1 and position == 0) {
            zeroes -= 1;
        }
        position += sign * amount;
        const winding = try std.math.divFloor(i32, position, 100);
        zeroes += sign * winding;
        position -= 100 * winding;
        if (sign == -1 and position == 0) {
            zeroes += 1;
        }
    }
    return zeroes;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-1/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
