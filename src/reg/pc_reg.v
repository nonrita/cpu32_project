`timescale 1ns/1ps

// プログラムカウンタ (PC レジスタ)
// 同期リセット付き、reg32 を使用して実装
module pc_reg (
    input  wire        CLK,
    input  wire        RST,
    input  wire        PC_EN,      // PC 更新有効
    input  wire [31:0] PC_NEXT,    // 次の PC 値
    output wire [31:0] PC          // 現在の PC
);
    wire [31:0] pc_d;   // reg32 への入力（PC_EN でゲート）

    // PC_EN が 0 のとき自身の値でホールド、1 のとき PC_NEXT を入力
    assign pc_d = PC_EN ? PC_NEXT : PC;

    // reg32 で PC 値を保持
    reg32 pc_word (
        .CLK(CLK),
        .RST(RST),
        .D(pc_d),
        .Q(PC)
    );
endmodule
