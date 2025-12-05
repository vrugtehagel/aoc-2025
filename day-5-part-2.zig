const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-5/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(344423158480189, answer);
}
pub fn solution(input: []const u8) !u64 {
    var iterator = std.mem.splitSequence(u8, input, "\n\n");
    const range_list = iterator.next() orelse "";
    if (range_list.len == 0) return 0;
    const ranges_length = std.mem.count(u8, range_list, "\n") + 1;
    const allocator = std.heap.page_allocator;
    var ranges = try allocator.alloc(u64, ranges_length * 2);
    defer allocator.free(ranges);
    try parse_ranges_into(range_list, &ranges);
    while (reduce_ranges(&ranges)) continue;
    var index: u32 = 0;
    var fresh: u64 = 0;
    while (index < ranges.len) : (index += 2) {
        if (ranges[index] == 0) continue;
        const lower = ranges[index];
        const upper = ranges[index + 1];
        fresh += @intCast(upper + 1 - lower);
    }
    return fresh;
}

fn reduce_ranges(ranges: *[]u64) bool {
    var check_index: u32 = 0;
    while (check_index < ranges.len) : (check_index += 2) {
        if (ranges.*[check_index] == 0) continue;
        const check_lower = ranges.*[check_index];
        const check_upper = ranges.*[check_index + 1];
        var index: u32 = 0;
        while (index < ranges.len) : (index += 2) {
            if (check_index == index) continue;
            if (ranges.*[index] == 0) continue;
            const lower = ranges.*[index];
            const upper = ranges.*[index + 1];
            if (upper < check_lower) continue;
            if (lower > check_upper) continue;
            const high = if (upper > check_upper) upper else check_upper;
            const low = if (lower < check_lower) lower else check_lower;
            ranges.*[index] = low;
            ranges.*[index + 1] = high;
            ranges.*[check_index] = 0;
            ranges.*[check_index + 1] = 0;
            return true;
        }
    }
    return false;
}

fn parse_ranges_into(range_list: []const u8, ranges: *[]u64) !void {
    var index: u32 = 0;
    var parts = std.mem.splitScalar(u8, range_list, '\n');
    while (parts.next()) |range| : (index += 2) {
        var range_parts = std.mem.splitScalar(u8, range, '-');
        const start = range_parts.next() orelse "";
        const end = range_parts.next() orelse "";
        if (start.len == 0 or end.len == 0) continue;
        ranges.*[index] = try std.fmt.parseUnsigned(u64, start, 10);
        ranges.*[index + 1] = try std.fmt.parseUnsigned(u64, end, 10);
    }
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-5/input.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
