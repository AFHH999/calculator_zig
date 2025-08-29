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
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    // First number
    var buffer1: [1024]u8 = undefined;
    try stdout.print("Enter your number: ", .{});
    const line1 = try stdin.readUntilDelimiterOrEof(&buffer1, '\n');

    const num1 = std.fmt.parseFloat(f64, std.mem.trim(u8, line1.?, " \n\t\r")) catch |err| {
        print("Invalid input, errors:{any}\n", .{err});
        return error.InvalidInput;
    };

    //Operation
    var buffer2: [1024]u8 = undefined;
    try stdout.print("Select the operation you want to perform\n" ++
        "Enter '/' for a division\n" ++
        "Enter '+' for addition\n" ++
        "Enter '-' for a subtraction\n" ++
        "Enter '*' for a multiplication\n" ++
        "Press 'q' to exit\n", .{});
    const op_line = try stdin.readUntilDelimiterOrEof(&buffer2, '\n');
    if (op_line == null or op_line.?.len == 0) return error.InvalidOperation;
    const operation = op_line.?[0];

    // Second number
    var buffer3: [1024]u8 = undefined;
    try stdout.print("Enter your number: ", .{});
    const line2 = try stdin.readUntilDelimiterOrEof(&buffer3, '\n');

    const num2 = std.fmt.parseFloat(f64, std.mem.trim(u8, line2.?, " \n\t\r")) catch |err| {
        print("No input recived, errors:{any}\n", .{err});
        return error.InvalidInput;
    };

    return Inputs{
        .num1 = num1,
        .num2 = num2,
        .operation = operation,
    };
}

fn calculating(inputs: Inputs) !void {
    var result: f64 = 0;
    var valid_operation = true;

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

            valid_operation = false;
        },
    }
    if (valid_operation) {
        print("{d} {c} {d} = {d}\n", .{ inputs.num1, inputs.operation, inputs.num2, result });
    }
}
