const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-8/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(140008, answer);
}
pub fn solution(input: []const u8) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var vertices = std.ArrayList([3]i32).empty;
    defer vertices.deinit(allocator);
    var raw_parts = std.mem.splitAny(u8, input, "\n,");
    while (raw_parts.peek() != null) {
        const raw_x = raw_parts.next() orelse "";
        const raw_y = raw_parts.next() orelse "";
        const raw_z = raw_parts.next() orelse "";
        if (raw_x.len == 0 or raw_y.len == 0 or raw_z.len == 0) break;
        const x = try std.fmt.parseInt(i32, raw_x, 10);
        const y = try std.fmt.parseInt(i32, raw_y, 10);
        const z = try std.fmt.parseInt(i32, raw_z, 10);
        const vertex: [3]i32 = .{ x, y, z };
        try vertices.append(allocator, vertex);
    }
    const max = std.math.maxInt(i64);
    const size = vertices.items.len;
    const capacity = std.math.pow(usize, size, 2);
    var lengths = try std.ArrayList(i64).initCapacity(allocator, capacity);
    defer lengths.deinit(allocator);
    lengths.expandToCapacity();
    @memset(lengths.items, max);
    for (vertices.items, 0..) |vertex_1, index_1| {
        for (0..index_1) |index_2| {
            const vertex_2 = vertices.items[index_2];
            const length = distance(vertex_1, vertex_2);
            lengths.items[index_1 * size + index_2] = length;
        }
    }
    const log_10_count = std.math.log10_int(vertices.items.len);
    var count = std.math.pow(usize, 10, log_10_count);
    var edges = try std.ArrayList([2]usize).initCapacity(allocator, count);
    while (count > 0) : (count -= 1) {
        const index = std.mem.indexOfMin(i64, lengths.items);
        lengths.items[index] = max;
        const index_1 = try std.math.divFloor(usize, index, size);
        const index_2 = index - size * index_1;
        try edges.append(allocator, .{ index_1, index_2 });
    }
    var circuit = std.AutoHashMap(usize, void).init(allocator);
    var circuit_sizes = std.ArrayList(usize).empty;
    while (edges.items.len > 0) {
        const first_edge = edges.pop() orelse return error.UnknownError;
        try circuit.put(first_edge[0], {});
        try circuit.put(first_edge[1], {});
        var did_append = true;
        appending: while (did_append) {
            did_append = false;
            var circuit_iterator = circuit.keyIterator();
            while (circuit_iterator.next()) |vertex_index| {
                for (edges.items, 0..) |edge, index| {
                    if (vertex_index.* == edge[0]) {
                        try circuit.put(edge[1], {});
                    } else if (vertex_index.* == edge[1]) {
                        try circuit.put(edge[0], {});
                    } else continue;
                    _ = edges.swapRemove(index);
                    did_append = true;
                    continue :appending;
                }
            }
        }
        try circuit_sizes.append(allocator, circuit.count());
        circuit.clearAndFree();
    }
    while (circuit_sizes.items.len < 3) {
        try circuit_sizes.append(allocator, 1);
    }
    var result: usize = 1;
    for (0..3) |_| {
        const index = std.mem.indexOfMax(usize, circuit_sizes.items);
        result *= circuit_sizes.items[index];
        circuit_sizes.items[index] = 0;
    }
    return result;
}

fn distance(vertex_1: [3]i32, vertex_2: [3]i32) i64 {
    var total: i64 = 0;
    for (vertex_1, 0..) |coordinate_1, index| {
        const coordinate_2 = vertex_2[index];
        const square = std.math.pow(i64, coordinate_1 - coordinate_2, 2);
        total += square;
    }
    return total;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-8/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
