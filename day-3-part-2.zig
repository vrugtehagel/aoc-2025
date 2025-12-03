const std = @import("std");

test {
    const input = @embedFile("./aoc-2025-assets/day-3/input.txt");
    const answer = try solution(input);
    try std.testing.expectEqual(170147128753455, answer);
}
pub fn solution(input: []const u8) !u64 {
    var banks = std.mem.splitScalar(u8, input, '\n');
    var result: u64 = 0;
    while (banks.next()) |bank| {
        if (bank.len == 0) continue;
        result += try get_bank_rating(bank, 12);
    }
    return result;
}

fn get_bank_rating(bank: []const u8, batteries: u8) !usize {
    if (batteries == 0) return 0;
    const index = std.mem.indexOfMax(u8, bank[0..(bank.len - batteries + 1)]);
    if (bank[index] < '0' or bank[index] > '9') return error.Overflow;
    const jolt = bank[index] - '0';
    const remaining = try get_bank_rating(bank[(index + 1)..], batteries - 1);
    return std.math.pow(usize, 10, batteries - 1) * jolt + remaining;
}

pub fn main() !void {
    const input = @embedFile("./aoc-2025-assets/day-3/example.txt");
    const answer = try solution(input);
    std.debug.print("{d}\n", .{answer});
}
