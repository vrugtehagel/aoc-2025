const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-2/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(65794984339, answer);
}
pub fn solution(input: []const u8) !u64 {
    var ranges = std.mem.splitAny(u8, input, ",\n");
    var result: u64 = 0;
    const allocator = std.heap.page_allocator;
    var seen = std.AutoHashMap(u64, void).init(allocator);
    while (ranges.next()) |range| {
        if (range.len == 0) continue;
        var bounds = std.mem.splitScalar(u8, range, '-');
        const start = bounds.next() orelse "";
        const end = bounds.next() orelse "";
        const min = try std.fmt.parseUnsigned(u64, start, 10);
        const max = try std.fmt.parseUnsigned(u64, end, 10);
        for (1..(start.len + 1)) |width| {
            const factor = std.math.pow(u64, 10, width);
            var repeater: u64 = factor + 1;
            while (repeater < max) : ({
                repeater *= factor;
                repeater += 1;
            }) {
                if (repeater * factor < min) continue;
                for ((factor / 10)..factor) |repeat| {
                    const candidate = repeater * repeat;
                    if (max < candidate) break;
                    if (min > candidate) continue;
                    if (seen.contains(candidate)) continue;
                    try seen.put(candidate, {});
                    result += candidate;
                }
            }
        }
    }
    return result;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-2/input.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
