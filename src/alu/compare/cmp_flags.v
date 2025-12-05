`timescale 1ns/1ps
`include "alu_defs.vh"

// フラグ生成: Zero, Negative, Carry, Overflow
module cmp_flags (
    input  wire [31:0] Y,
    input  wire        carry_in,   // adder からのキャリーアウト (unsigned)
    input  wire        overflow_in,// adder からのオーバーフロー (signed)
    output wire [3:0]  FLAGS       // {V,C,N,Z} の順ではなく、インデックス定義に合わせる
);
    wire z, n, c, v;
    assign z = (Y == 32'b0);
    assign n = Y[31];
    assign c = carry_in;
    assign v = overflow_in;

    assign FLAGS[`ALU_FLAG_Z] = z;
    assign FLAGS[`ALU_FLAG_N] = n;
    assign FLAGS[`ALU_FLAG_C] = c;
    assign FLAGS[`ALU_FLAG_V] = v;
endmodule
