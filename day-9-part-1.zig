const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-9/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(4749838800, answer);
}
pub fn solution(input: []const u8) !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var lines = std.mem.splitScalar(u8, input, '\n');
    var tiles = std.ArrayList([2]i32).empty;
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var parts = std.mem.splitScalar(u8, line, ',');
        const raw_x = parts.next() orelse "";
        const raw_y = parts.next() orelse "";
        const x = try std.fmt.parseInt(i32, raw_x, 10);
        const y = try std.fmt.parseInt(i32, raw_y, 10);
        try tiles.append(allocator, .{ x, y });
    }
    var maximum: u64 = 0;
    for (tiles.items) |top_left| {
        for (tiles.items) |bottom_right| {
            const width: i64 = @intCast(1 + top_left[0] - bottom_right[0]);
            const height: i64 = @intCast(1 + top_left[1] - bottom_right[1]);
            const size = @abs(width * height);
            if (size <= maximum) continue;
            maximum = size;
        }
    }
    return maximum;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-9/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
