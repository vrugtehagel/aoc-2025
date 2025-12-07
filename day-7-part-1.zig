const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-7/input.txt");
    const answer = solution(input);
    try std.testing.expectEqual(1560, answer);
}
pub fn solution(input: []const u8) u32 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var beams: [512]bool = undefined;
    var splits: u32 = 0;
    const first_line = lines.next() orelse "";
    const start_column = std.mem.indexOfScalar(u8, first_line, 'S') orelse 0;
    beams[start_column] = true;
    while (lines.next()) |line| {
        for (line, 0..) |maybe_splitter, index| {
            if (maybe_splitter != '^') continue;
            if (!beams[index]) continue;
            beams[index - 1] = true;
            beams[index] = false;
            beams[index + 1] = true;
            splits += 1;
        }
    }
    return splits;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-7/example.txt");
    const answer = solution(input);
    std.debug.print("{d}\n", .{answer});
}
