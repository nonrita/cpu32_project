`timescale 1ns/1ps

// 32-bit adder/subtractor
// sub=0: SUM = A + B
// sub=1: SUM = A - B (two's complement)
module adder32 (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        sub,
    output wire [31:0] SUM,
    output wire        CARRY_OUT,
    output wire        OVERFLOW
);
    wire [31:0] B_eff;
    wire        cin;
    wire [32:0] add_res;

    assign B_eff   = sub ? ~B : B;
    assign cin     = sub;
    assign add_res = {1'b0, A} + {1'b0, B_eff} + cin;

    assign SUM       = add_res[31:0];
    assign CARRY_OUT = add_res[32];
    // オーバーフロー: 同符号の A,B_eff を加算した結果が符号反転したとき
    assign OVERFLOW  = (A[31] == B_eff[31]) && (SUM[31] != A[31]);
endmodule
