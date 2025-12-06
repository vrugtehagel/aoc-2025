const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-6/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(9625320374409, answer);
}
pub fn solution(input: []const u8) !u64 {
    const width = (std.mem.indexOfScalar(u8, input, '\n') orelse 0) + 1;
    const height = std.mem.count(u8, input, "\n");
    var result: u64 = 0;
    var total: u64 = 0;
    var operator: u8 = '+';
    for (0..width) |x| {
        const maybe_operator = input[width * (height - 1) + x];
        if (maybe_operator != ' ') {
            operator = maybe_operator;
        }
        var value: u64 = 0;
        for (0..(height - 1)) |y| {
            const digit = input[width * y + x];
            if (digit < '0' or '9' < digit) continue;
            value = value * 10 + (digit - '0');
        }
        if (value == 0) {
            result += total;
            total = 0;
        } else if (total == 0) {
            total = value;
        } else if (operator == '+') {
            total += value;
        } else if (operator == '*') {
            total *= value;
        } else {
            return error.InvalidInput;
        }
    }
    return result;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-6/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
