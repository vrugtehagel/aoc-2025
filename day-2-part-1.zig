const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-2/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(40398804950, answer);
}
pub fn solution(input: []const u8) !u64 {
    var ranges = std.mem.splitAny(u8, input, ",\n");
    var result: u64 = 0;
    while (ranges.next()) |range| {
        if (range.len == 0) continue;
        var bounds = std.mem.splitScalar(u8, range, '-');
        const start = bounds.next() orelse "";
        const end = bounds.next() orelse "";
        const min = try std.fmt.parseUnsigned(u64, start, 10);
        const max = try std.fmt.parseUnsigned(u64, end, 10);
        const min_half = try get_min_half(start);
        const max_half = try get_max_half(end);
        for (min_half..(max_half + 1)) |half| {
            const candidate = double_number(half);
            if (min > candidate) continue;
            if (max < candidate) break;
            result += candidate;
        }
    }
    return result;
}

fn get_min_half(start: []const u8) !u64 {
    const length = (start.len + 1) >> 1;
    if (start.len & 1 == 1) return std.math.pow(usize, 10, length - 1);
    return try std.fmt.parseUnsigned(u64, start[0..length], 10);
}

fn get_max_half(end: []const u8) !u64 {
    const length = end.len >> 1;
    if (end.len & 1 == 1) return std.math.pow(usize, 10, length) - 1;
    return try std.fmt.parseUnsigned(u64, end[0..length], 10);
}

fn double_number(number: u64) u64 {
    const length = std.math.log10_int(number) + 1;
    return number * (std.math.pow(usize, 10, length) + 1);
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-2/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
