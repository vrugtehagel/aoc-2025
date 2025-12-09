const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-8/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(9253260633, answer);
}
pub fn solution(input: []const u8) !usize {
    // To be implemented
    // Solution was found using the previous solution;
    // A sort of quick-and-dirty manual binary search.
    // An implementation of this solution would be too slow for my taste.

    // Returning the input length so Zig doesn't complain
    return @intCast(input.len);
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-8/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
