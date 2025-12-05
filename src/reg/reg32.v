`timescale 1ns/1ps

// 32-bit レジスタ（同期アクティブ High リセット）
// 各ビットは既存のポジティブエッジトリガ d_ff で構成
module reg32 (
    input  wire        CLK,
    input  wire        RST,
    input  wire [31:0] D,
    output wire [31:0] Q
);
    wire [31:0] qn_unused; // 未使用の反転出力をまとめて捨てる

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_ff
            d_ff ff_i (
                .D(D[i]),
                .CLK(CLK),
                .RST(RST),
                .Q(Q[i]),
                .Qn(qn_unused[i])
            );
        end
    endgenerate
endmodule
