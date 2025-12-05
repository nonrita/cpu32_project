`timescale 1ns/1ps
`include "./alu_defs.vh"

module alu_core (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  alu_op,
    output reg  [31:0] Y,
    output wire [3:0]  FLAGS
);
    // 演算ブロック出力
    wire [31:0] add_y;
    wire        add_carry;
    wire        add_ovf;

    wire [31:0] and_y;
    wire [31:0] or_y;
    wire [31:0] xor_y;
    wire [31:0] not_y;

    wire [31:0] sh_y;

    wire [31:0] slt_y;

    // 付帯信号
    reg         sel_sub;
    reg  [1:0]  sh_mode;
    reg         slt_unsigned;
    wire        carry_flag;
    wire        ovf_flag;
    wire        is_arith;

    // adder (add/sub)
    adder32 u_adder (
        .A(A),
        .B(B),
        .sub(sel_sub),
        .SUM(add_y),
        .CARRY_OUT(add_carry),
        .OVERFLOW(add_ovf)
    );

    // logic
    and32 u_and (.A(A), .B(B), .Y(and_y));
    or32  u_or  (.A(A), .B(B), .Y(or_y));
    xor32 u_xor (.A(A), .B(B), .Y(xor_y));
    not32 u_not (.A(A),       .Y(not_y));

    // shift
    barrel_shifter u_shifter (
        .A(A),
        .SHAMT(B[4:0]),
        .MODE(sh_mode),
        .Y(sh_y)
    );

    // compare
    slt32 u_slt (
        .A(A),
        .B(B),
        .is_unsigned(slt_unsigned),
        .Y(slt_y)
    );

    // フラグ生成
    cmp_flags u_flags (
        .Y(Y),
        .carry_in(carry_flag),
        .overflow_in(ovf_flag),
        .FLAGS(FLAGS)
    );

    // デコード: 操作に応じた制御
    always @* begin
        // defaults
        sel_sub      = 1'b0;
        sh_mode      = 2'b00;
        slt_unsigned = 1'b0;
        Y            = 32'b0;

        case (alu_op)
            `ALU_OP_ADD: begin
                sel_sub = 1'b0;
                Y       = add_y;
            end
            `ALU_OP_SUB: begin
                sel_sub = 1'b1;
                Y       = add_y;
            end
            `ALU_OP_AND: Y = and_y;
            `ALU_OP_OR:  Y = or_y;
            `ALU_OP_XOR: Y = xor_y;
            `ALU_OP_NOT: Y = ~or_y; // NOR 相当 (A|B の否定)
            `ALU_OP_SLL: begin
                sh_mode = 2'b00;
                Y       = sh_y;
            end
            `ALU_OP_SRL: begin
                sh_mode = 2'b01;
                Y       = sh_y;
            end
            `ALU_OP_SRA: begin
                sh_mode = 2'b10;
                Y       = sh_y;
            end
            `ALU_OP_SLT: begin
                slt_unsigned = 1'b0;
                Y            = slt_y;
            end
            `ALU_OP_SLTU: begin
                slt_unsigned = 1'b1;
                Y            = slt_y;
            end
            default: begin
                Y = add_y;
            end
        endcase

    end

    // 算術演算のときだけ carry/overflow を出力。それ以外は 0。
    assign is_arith   = (alu_op == `ALU_OP_ADD) || (alu_op == `ALU_OP_SUB);
    assign carry_flag = is_arith ? add_carry : 1'b0;
    assign ovf_flag   = is_arith ? add_ovf   : 1'b0;

endmodule
