const std = @import("std");
const print = std.debug.print;

// struct to hold the values we need.
const Inputs = struct {
    num1: f64,
    num2: f64,
    operation: u8,
};

pub fn main() !void {
    const user_inputs = try GetUserInput();
    try calculating(user_inputs);
}

fn GetUserInput() !Inputs {
    const stdin = std.fs.File.stdin();
    const stdout = std.fs.File.stdout();
    const stderr = std.fs.File.stderr();

    var stdout_buffer: [4096]u8 = undefined;
    var stdin_buffer: [4096]u8 = undefined;
    var stderr_buffer: [4096]u8 = undefined;

    var file_reader = stdin.reader(&stdin_buffer);
    var file_wrider = stdout.writer(&stdout_buffer);
    var stderr_file = stderr.writer(&stderr_buffer);

    const stdout_writer_interface = &file_wrider.interface;
    const stdin_reader_interface = &file_reader.interface;
    const stderr_writer_interface = &stderr_file.interface;

    // First number
    try stdout_writer_interface.writeAll("Write your first number: ");
    try stdout_writer_interface.flush();
    const value_arr = stdin_reader_interface.takeDelimiterExclusive('\n') catch |err| {
        stderr_writer_interface.print("error: the input wasn't the expected, specific error: {any}", .{err}) catch {};
        stderr_writer_interface.flush() catch {};
        return err;
    };
    const num1 = try std.fmt.parseFloat(f64, value_arr);
    try stdout_writer_interface.flush();

    //Operation
    try stdout_writer_interface.writeAll(
        "Write the operation to perform\n" ++
            "'/' For division\n" ++
            "'+' For addition\n" ++
            "'-' For subtraction\n" ++
            "'*' For multiplication\n",
    );
    try stdout_writer_interface.flush();
    const value_op = stdin_reader_interface.takeDelimiterExclusive('\n') catch |err| {
        stderr_writer_interface.print("error: the input wasn't the expected, specific error: {any}", .{err}) catch {};
        stderr_writer_interface.flush() catch {};
        return err;
    };
    if (value_op.len == 0) return error.InvalidOperation;
    const operation = value_op[0];

    // Second number
    try stdout_writer_interface.writeAll("Write your second number: ");
    try stdout_writer_interface.flush();
    const value_arr_2 = stdin_reader_interface.takeDelimiterExclusive('\n') catch |err| {
        stderr_writer_interface.print("error: the input wasn't the expected, specific error: {any}", .{err}) catch {};
        stderr_writer_interface.flush() catch {};
        return err;
    };
    const num2 = try std.fmt.parseFloat(f64, value_arr_2);
    try stdout_writer_interface.flush();

    return Inputs{
        .num1 = num1,
        .num2 = num2,
        .operation = operation,
    };
}

fn calculating(inputs: Inputs) !void {
    var result: f64 = 0;

    switch (inputs.operation) {
        '+' => result = inputs.num1 + inputs.num2,
        '-' => result = inputs.num1 - inputs.num2,
        '*' => result = inputs.num1 * inputs.num2,
        '/' => {
            if (inputs.num2 == 0) {
                print("You can't divede by zero\n", .{});
                return;
            }
            result = inputs.num1 / inputs.num2;
        },
        else => {
            print("Error: Invalid operation, valid ones: {c}\n", .{inputs.operation});
            return;
        },
    }
    print("{d} {c} {d} = {d}\n", .{ inputs.num1, inputs.operation, inputs.num2, result });
}
