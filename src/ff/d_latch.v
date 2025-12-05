`timescale 1ns/1ps

// アクティブ High のレベル感知 D ラッチ（NAND ベースの SR ラッチを内部で利用）
// EN=1 の間は D を透過し、EN=0 で値を保持する
module d_latch (
    input  wire D,   // データ入力
    input  wire EN,  // イネーブル（High で透過）
    output wire Q,
    output wire Qn
);
    wire s_n; // SR ラッチの S (active-low)
    wire r_n; // SR ラッチの R (active-low)

    // ゲート生成: EN が Low なら両方 1 となり保持、EN が High なら D に応じてセット/リセット
    assign s_n = ~(D  & EN);   // D=1 かつ EN=1 でセット（S_n=0）
    assign r_n = ~(~D & EN);   // D=0 かつ EN=1 でリセット（R_n=0）

    // 既存の NAND 型 SR ラッチを利用（S,R はアクティブ Low）
    sr_latch sr_inst (
        .S(s_n),
        .R(r_n),
        .Q(Q),
        .Qn(Qn)
    );
endmodule
