`timescale 1ns/1ps
`include "alu_defs.vh"

// CPU トップモジュール（シングルサイクル MIPS 風）
module cpu_top (
    input  wire        CLK,
    input  wire        RST
);
    // PC 関連信号
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    
    // 命令メモリ（仮：ダミー命令を返す）
    wire [31:0] instr;
    
    // レジスタファイル信号
    wire [4:0]  rs;
    wire [4:0]  rt;
    wire [4:0]  rd;
    wire [4:0]  rf_waddr;
    wire [31:0] rf_wdata;
    wire        rf_we;
    wire [31:0] rf_rdata1;
    wire [31:0] rf_rdata2;
    
    // ALU 信号
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [3:0]  alu_op;
    wire [31:0] alu_result;
    wire [3:0]  alu_flags;
    
    // 制御信号（簡易版：今は全て 1 でパススルー）
    wire        pc_en;
    
    assign pc_en = 1'b1;  // 常に PC 更新
    
    // ========== PC レジスタ ==========
    assign pc_plus4 = pc + 32'd4;  // PC + 4
    assign pc_next  = pc_plus4;     // 分岐なしなので常に +4
    
    pc_reg u_pc (
        .CLK(CLK),
        .RST(RST),
        .PC_EN(pc_en),
        .PC_NEXT(pc_next),
        .PC(pc)
    );
    
    // ========== 命令メモリ ==========
    imem u_imem (
        .addr(pc),
        .instr(instr)
    );
    
    // ========== 命令デコード ==========
    wire [5:0] opcode;
    wire [5:0] funct;
    wire [15:0] imm;
    wire [31:0] imm_ext;
    
    assign opcode = instr[31:26];
    assign rs     = instr[25:21];
    assign rt     = instr[20:16];
    assign rd     = instr[15:11];
    assign funct  = instr[5:0];
    assign imm    = instr[15:0];
    
    // 即値の符号拡張
    assign imm_ext = {{16{imm[15]}}, imm};
    
    // R-type: opcode = 000000, I-type: opcode != 000000
    wire is_rtype;
    assign is_rtype = (opcode == 6'b000000);
    
    // レジスタファイル制御
    assign rf_waddr = is_rtype ? rd : rt;  // R-type は rd, I-type は rt に書き込み
    assign rf_we    = 1'b1;  // 常に書き込み（NOP 以外）
    assign rf_wdata = alu_result;
    
    // ========== レジスタファイル ==========
    regfile u_regfile (
        .CLK(CLK),
        .RST(RST),
        .WE(rf_we),
        .WADDR(rf_waddr),
        .WDATA(rf_wdata),
        .RADDR1(rs),
        .RADDR2(rt),
        .RDATA1(rf_rdata1),
        .RDATA2(rf_rdata2)
    );
    
    // ========== ALU ==========
    // ALU オペランド B は R-type では rf_rdata2、I-type では即値
    assign alu_a  = rf_rdata1;
    assign alu_b  = is_rtype ? rf_rdata2 : imm_ext;
    
    // ALU 制御デコーダ
    alu_ctrl u_alu_ctrl (
        .opcode(opcode),
        .funct(funct),
        .alu_op(alu_op)
    );
    
    alu_core u_alu (
        .A(alu_a),
        .B(alu_b),
        .alu_op(alu_op),
        .Y(alu_result),
        .FLAGS(alu_flags)
    );

endmodule
