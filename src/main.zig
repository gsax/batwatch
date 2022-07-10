const std = @import("std");

const Parameter = struct {
    name: []const u8,
    path: []const u8,
};

pub fn main() anyerror!void {
    var parameter: [2]Parameter = undefined;

    parameter[0] = Parameter{
        .name = "temp1_max",
        .path = "/sys/class/hwmon/hwmon0/temp1_max",
    };
    parameter[1] = Parameter{
        .name = "temp2_max",
        .path = "/sys/class/hwmon/hwmon0/temp2_max",
    };

    for (parameter) |watch| {
        try watcher(watch);
    }
}

fn watcher(parameter: Parameter) !void {
    const max_bytes_per_line = 4096;
    const alloc = std.heap.page_allocator;

    // var file = std.fs.cwd().openFile("/sys/class/hwmon/hwmon0/temp1_max", .{}) catch {
    var file = std.fs.cwd().openFile(parameter.path, .{}) catch {
        return;
    };
    defer file.close();
    var reader = std.io.bufferedReader(file.reader()).reader();

    while (try reader.readUntilDelimiterOrEofAlloc(alloc, '\n', max_bytes_per_line)) |line| {
        // while (try reader.readUntilDelimiter([_]u8{}, '\n')) |line| {
        defer alloc.free(line);
        const stdout = std.io.getStdOut().writer();
        try stdout.print("{s}: {s}\n", .{ parameter.name, line });
    }
}

//    /sys/class/power_supply/BAT0/alarm
//    /sys/class/power_supply/BAT0/capacity
//    /sys/class/power_supply/BAT0/capacity_level
//    /sys/class/power_supply/BAT0/charge_behaviour
//    /sys/class/power_supply/BAT0/charge_control_end_threshold
//    /sys/class/power_supply/BAT0/charge_control_start_threshold
//    /sys/class/power_supply/BAT0/charge_start_threshold
//    /sys/class/power_supply/BAT0/charge_stop_threshold
//    /sys/class/power_supply/BAT0/cycle_count
//    /sys/class/power_supply/BAT0/device
//    /sys/class/power_supply/BAT0/energy_full
//    /sys/class/power_supply/BAT0/energy_full_design
//    /sys/class/power_supply/BAT0/energy_now
//    /sys/class/power_supply/BAT0/hwmon2/
//    /sys/class/power_supply/BAT0/hwmon2/device
//    /sys/class/power_supply/BAT0/hwmon2/in0_input
//    /sys/class/power_supply/BAT0/hwmon2/name
//    /sys/class/power_supply/BAT0/hwmon2/power/
//    /sys/class/power_supply/BAT0/hwmon2/power/autosuspend_delay_ms
//    /sys/class/power_supply/BAT0/hwmon2/power/control
//    /sys/class/power_supply/BAT0/hwmon2/power/runtime_active_time
//    /sys/class/power_supply/BAT0/hwmon2/power/runtime_status
//    /sys/class/power_supply/BAT0/hwmon2/power/runtime_suspended_time
//    /sys/class/power_supply/BAT0/hwmon2/subsystem
//    /sys/class/power_supply/BAT0/hwmon2/uevent
//    /sys/class/power_supply/BAT0/manufacturer
//    /sys/class/power_supply/BAT0/model_name
//    /sys/class/power_supply/BAT0/power/
//    /sys/class/power_supply/BAT0/power/autosuspend_delay_ms
//    /sys/class/power_supply/BAT0/power/control
//    /sys/class/power_supply/BAT0/power/runtime_active_time
//    /sys/class/power_supply/BAT0/power/runtime_status
//    /sys/class/power_supply/BAT0/power/runtime_suspended_time
//    /sys/class/power_supply/BAT0/power_now
//    /sys/class/power_supply/BAT0/present
//    /sys/class/power_supply/BAT0/serial_number
//    /sys/class/power_supply/BAT0/status
//    /sys/class/power_supply/BAT0/subsystem
//    /sys/class/power_supply/BAT0/technology
//    /sys/class/power_supply/BAT0/type
//    /sys/class/power_supply/BAT0/uevent
//    /sys/class/power_supply/BAT0/voltage_min_design
//    /sys/class/power_supply/BAT0/voltage_now
