const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-5/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(505, answer);
}
pub fn solution(input: []const u8) !u32 {
    var iterator = std.mem.splitSequence(u8, input, "\n\n");
    const range_list = iterator.next() orelse "";
    const food_list = iterator.next() orelse "";
    if (range_list.len == 0 or food_list.len == 0) return 0;
    const ranges_length = std.mem.count(u8, range_list, "\n") + 1;
    const allocator = std.heap.page_allocator;
    var ranges = try allocator.alloc(u64, ranges_length * 2);
    defer allocator.free(ranges);
    try parse_ranges_into(range_list, &ranges);
    var raw_foods = std.mem.splitScalar(u8, food_list, '\n');
    var fresh: u32 = 0;
    while (raw_foods.next()) |raw_food| {
        if (raw_food.len == 0) continue;
        const food = try std.fmt.parseUnsigned(u64, raw_food, 10);
        var index: u32 = 0;
        while (index < ranges.len) : (index += 2) {
            const start = ranges[index];
            if (start > food) continue;
            const end = ranges[index + 1];
            if (end < food) continue;
            fresh += 1;
            break;
        }
    }
    return fresh;
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
    const input = @embedFile("./aoc-2025-assets/day-5/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
