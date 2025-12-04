const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-4/input.txt");
    const answer = solution(input);
    try std.testing.expectEqual(8707, answer);
}
pub fn solution(input: []const u8) !u32 {
    var result: u32 = 0;
    const room_width = get_room_width(input);
    const offsets = get_neighbour_offsets(room_width);
    const allocator = std.heap.page_allocator;
    var room: []u8 = try allocator.dupe(u8, input);
    defer allocator.free(room);
    var none_removed = false;
    while (!none_removed) {
        none_removed = true;
        for (room, 0..) |character, index| {
            if (character != '@') continue;
            var neighbours: u8 = 0;
            for (offsets) |offset| {
                const position = @as(i32, @intCast(index)) + offset;
                if (position < 0) continue;
                if (position >= room.len) break;
                if (room[@intCast(position)] == '@') {
                    neighbours += 1;
                }
            }
            if (neighbours < 4) {
                result += 1;
                room[index] = '.';
                none_removed = false;
            }
        }
    }
    return result;
}

fn get_neighbour_offsets(room_width: usize) [8]i32 {
    const width = 1 + @as(i32, @intCast(room_width));
    return .{
        -1 * width - 1,
        -width,
        -width + 1,
        -1,
        1,
        width - 1,
        width,
        width + 1,
    };
}

fn get_room_width(input: []const u8) usize {
    for (input, 0..) |character, index| {
        if (character == '\n') return index;
    }
    return input.len;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-4/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
