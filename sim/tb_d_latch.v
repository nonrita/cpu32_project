`timescale 1ns/1ps

module tb_d_latch;
    reg D;
    reg EN;
    wire Q;
    wire Qn;

    // D ラッチ (アクティブ High, 内部 NAND SR) のインスタンス
    d_latch uut (
        .D(D),
        .EN(EN),
        .Q(Q),
        .Qn(Qn)
    );

    initial begin
        // 初期状態: リセットをかけて既知状態へ (Q=0, Qn=1)
        EN = 1; D = 0;
        #10;
        EN = 0; // ホールドへ
        #10;

        // テスト1: ホールド確認 (Q=0 維持)
        $display("テスト1: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS ホールド(0)"); else $display("✗ FAIL ホールド(0) 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);

        // テスト2: 透過セット (EN=1, D=1) で Q=1
        EN = 1; D = 1;
        #10;
        $display("テスト2: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS セット"); else $display("✗ FAIL セット 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);

        // テスト3: ホールド (EN=0) で Q=1 を保持
        EN = 0;
        #10;
        $display("テスト3: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS ホールド(1)"); else $display("✗ FAIL ホールド(1) 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);

        // テスト4: EN=0 のまま D を 0 に変化させても保持すること
        D = 0;
        #10;
        $display("テスト4: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS ホールド中の入力変化無視"); else $display("✗ FAIL ホールド中に変化 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);

        // テスト5: 透過リセット (EN=1, D=0) で Q=0
        EN = 1; D = 0;
        #10;
        $display("テスト5: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS リセット"); else $display("✗ FAIL リセット 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);

        // テスト6: ホールド (EN=0) で Q=0 を保持
        EN = 0;
        #10;
        $display("テスト6: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS ホールド(0) 再確認"); else $display("✗ FAIL ホールド(0) 再確認 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);

        // テスト7: EN=1 で D を 0->1 に変化させ、透過動作を確認
        EN = 1; D = 0; #5; // 半期で確認
        D = 1; #10;
        $display("テスト7: EN=%b, D=%b -> Q=%b, Qn=%b", EN, D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS 透過動作"); else $display("✗ FAIL 透過動作 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);

        // シミュレーション終了
        $finish;
    end
endmodule
