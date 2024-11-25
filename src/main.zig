const std = @import("std");
const rl = @import("raylib.zig");

pub fn main() !void {
    const width = 800;
    const height = 450;

    rl.SetConfigFlags(rl.FLAG_MSAA_4X_HINT | rl.FLAG_VSYNC_HINT);
    rl.InitWindow(width, height, "breakout");
    defer rl.CloseWindow();

    var gpa = std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 8 }){};
    const allocator = gpa.allocator();
    defer {
        switch (gpa.deinit()) {
            .leak => @panic("GPA leaked memory!"),
            else => {},
        }
    }

    const colors = [_]rl.Color{ rl.GRAY, rl.WHITE, rl.GOLD, rl.LIME, rl.BLUE, rl.VIOLET, rl.BROWN };
    const colors_len: i32 = @intCast(colors.len);
    var current_color: i32 = 2;
    var hint = true;

    while (!rl.WindowShouldClose()) {
        var delta: i2 = 0;
        if (rl.IsKeyPressed(rl.KEY_UP)) delta += 1;
        if (rl.IsKeyPressed(rl.KEY_DOWN)) delta -= 1;
        if (delta != 0) {
            current_color = @mod(current_color + delta, colors_len);
            hint = false;
        }

        // Draw
        {
            rl.BeginDrawing();
            defer rl.EndDrawing();

            rl.ClearBackground(colors[@intCast(current_color)]);
            if (hint) rl.DrawText("press up or down arrow to change background color", 120, 140, 20, rl.BLUE);
            rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.BLACK);

            const seconds: u32 = @intFromFloat(rl.GetTime());
            const dynamic = try std.fmt.allocPrintZ(allocator, "running since {d} seconds", .{seconds});
            defer allocator.free(dynamic);
            rl.DrawText(dynamic, 300, 250, 20, rl.WHITE);

            rl.DrawFPS(width - 100, 10);
        }
    }
}
