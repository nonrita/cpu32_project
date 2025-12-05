`timescale 1ns/1ps

// ポジティブエッジトリガの D フリップフロップ（同期リセット）
module d_ff (
    input  wire D,
    input  wire CLK,
    input  wire RST, // 同期アクティブ High リセット
    output wire Q,
    output wire Qn
);
    wire d_mux;      // リセット時は 0 を与える同期リセット用 MUX 出力
    wire m_q;        // マスターラッチ出力
    wire m_qn;

    assign d_mux = RST ? 1'b0 : D;

    // マスター: CLK=0 の間だけ透過
    d_latch master (
        .D(d_mux),
        .EN(~CLK),
        .Q(m_q),
        .Qn(m_qn)
    );

    // スレーブ: CLK=1 の間だけ透過 → 立ち上がりでデータを確定
    d_latch slave (
        .D(m_q),
        .EN(CLK),
        .Q(Q),
        .Qn(Qn)
    );
endmodule
