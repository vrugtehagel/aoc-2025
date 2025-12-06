const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-6/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(4387670995909, answer);
}
pub fn solution(input: []const u8) !u64 {
    var lines = std.mem.splitBackwardsScalar(u8, input, '\n');
    const allocator = std.heap.page_allocator;
    var totals: []u64 = try allocator.alloc(u64, 1 << 12);
    @memset(totals, 0);
    defer allocator.free(totals);
    var first_line: []const u8 = undefined;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        first_line = line;
        break;
    }
    if (first_line.len == 0) return error.InvalidInput;
    var operators = std.mem.splitScalar(u8, first_line, ' ');
    var index: usize = 0;
    while (lines.next()) |line| {
        operators.reset();
        index = 0;
        var numbers = std.mem.splitScalar(u8, line, ' ');
        while (numbers.next()) |raw_number| {
            if (raw_number.len == 0) continue;
            var operator: u8 = '?';
            while (operators.next()) |part| {
                if (part.len == 0) continue;
                operator = part[0];
                break;
            }
            const number = try std.fmt.parseInt(u64, raw_number, 10);
            if (totals[index] == 0) {
                totals[index] = number;
            } else if (operator == '+') {
                totals[index] += number;
            } else if (operator == '*') {
                totals[index] *= number;
            } else {
                return error.InvalidInput;
            }
            index += 1;
        }
    }
    var result: u64 = 0;
    for (totals) |total| {
        result += total;
    }
    return result;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-6/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
