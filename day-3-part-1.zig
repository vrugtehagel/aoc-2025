const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-3/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(17092, answer);
}
pub fn solution(input: []const u8) !u64 {
    var banks = std.mem.splitScalar(u8, input, '\n');
    var result: u64 = 0;
    while (banks.next()) |bank| {
        if (bank.len == 0) continue;
        result += try get_bank_rating(bank);
    }
    return result;
}

fn get_bank_rating(bank: []const u8) !u64 {
    var index = bank.len - 2;
    var jolts: [2]u8 = .{ bank[index], bank[index + 1] };
    while (index > 0) {
        index -= 1;
        const jolt = bank[index];
        if (jolts[0] > jolt) continue;
        if (jolts[0] > jolts[1]) {
            jolts[1] = jolts[0];
        }
        jolts[0] = jolt;
    }
    if (jolts[0] < '0' or jolts[0] > '9') return error.Overflow;
    if (jolts[1] < '0' or jolts[1] > '9') return error.Overflow;
    jolts[0] -= '0';
    jolts[1] -= '0';
    const result = 10 * jolts[0] + jolts[1];
    return result;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-3/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
