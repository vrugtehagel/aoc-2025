const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-9/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(1624057680, answer);
}
pub fn solution(input: []const u8) !u64 {
    // To be implemented
    // Solution was found by inspecting the grid manually.

    // Returning the input length so Zig doesn't complain
    return @intCast(input.len);
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-9/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
