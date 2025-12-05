`timescale 1ns/1ps

module not32 (
    input  wire [31:0] A,
    output wire [31:0] Y
);
    assign Y = ~A;
endmodule
