`timescale 1ns/1ps

// 32x32 レジスタファイル
// - 1 つの同期書き込みポートと 2 つの非同期読み出しポート
// - 内部の各レジスタは既存の reg32（一語分の 32bit レジスタ）を利用
// - 同期アクティブ High リセットで全レジスタを 0 クリア
module regfile (
    input  wire        CLK,
    input  wire        RST,
    input  wire        WE,      // 書き込み有効 (posedge CLK で適用)
    input  wire [4:0]  WADDR,
    input  wire [31:0] WDATA,
    input  wire [4:0]  RADDR1,
    input  wire [4:0]  RADDR2,
    output wire [31:0] RDATA1,
    output wire [31:0] RDATA2
);
    // 各レジスタの出力を束ねる
    wire [31:0] reg_q   [0:31];
    wire [31:0] reg_d   [0:31];

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_reg
            // 書き込み対象なら WDATA、それ以外は自身の値でホールド
            localparam [4:0] IDX = i[4:0];
            assign reg_d[i] = (WE && (WADDR == IDX)) ? WDATA : reg_q[i];

            reg32 word_reg (
                .CLK(CLK),
                .RST(RST),
                .D(reg_d[i]),
                .Q(reg_q[i])
            );
        end
    endgenerate

    // 非同期読み出しポート
    assign RDATA1 = reg_q[RADDR1];
    assign RDATA2 = reg_q[RADDR2];
endmodule
