const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
pub fn main() void {
    _ = @import("day-1-part-1.zig");
    _ = @import("day-1-part-2.zig");

    _ = @import("day-2-part-1.zig");
    _ = @import("day-2-part-2.zig");

    _ = @import("day-3-part-1.zig");
    _ = @import("day-3-part-2.zig");
}
