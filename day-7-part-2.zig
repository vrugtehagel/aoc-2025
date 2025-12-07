const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-7/input.txt");
    const answer = solution(input);
    try std.testing.expectEqual(25592971184998, answer);
}
pub fn solution(input: []const u8) u64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    var beams: [512]u64 = undefined;
    @memset(&beams, 0);
    const first_line = lines.next() orelse "";
    const start_column = std.mem.indexOfScalar(u8, first_line, 'S') orelse 0;
    beams[start_column] = 1;
    while (lines.next()) |line| {
        for (line, 0..) |maybe_splitter, index| {
            if (maybe_splitter != '^') continue;
            if (beams[index] == 0) continue;
            beams[index - 1] += beams[index];
            beams[index + 1] += beams[index];
            beams[index] = 0;
        }
    }
    var timelines: u64 = 0;
    for (beams) |beam| {
        timelines += beam;
    }
    return timelines;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-7/input.txt");
    const answer = solution(input);
    std.debug.print("{d}\n", .{answer});
}
