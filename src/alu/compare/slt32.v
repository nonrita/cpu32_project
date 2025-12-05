`timescale 1ns/1ps

// Signed/Unsigned less-than comparator: result in bit0, upper bits 0
module slt32 (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        is_unsigned,
    output wire [31:0] Y
);
    wire lt_signed;
    wire lt_unsigned;

    assign lt_signed   = ($signed(A) < $signed(B));
    assign lt_unsigned = (A < B);

    assign Y = {31'b0, is_unsigned ? lt_unsigned : lt_signed};
endmodule
