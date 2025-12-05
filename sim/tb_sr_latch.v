`timescale 1ns/1ps

module tb_sr_latch;
    reg  S;
    reg  R;
    wire Q;
    wire Qn;

    // SR ラッチ (NAND 型, S/R はアクティブ Low) のインスタンス
    sr_latch uut (
        .S(S),
        .R(R),
        .Q(Q),
        .Qn(Qn)
    );

    initial begin
        // 初期セット: S を Low でセットし、その後ホールド
        // 期待: Q=1, Qn=0 にセットされた状態でホールドに戻る
        S = 0; R = 1;  // セット
        #10;
        S = 1; R = 1;  // ホールドへ遷移
        #10;

        // テストケース1: ホールド (前段でセットした状態を保持) S=1,R=1
        $display("テストケース1: S = %b, R = %b, Q = %b, Qn = %b", S, R, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) begin
            $display("✓ PASS: テストケース1 - ホールド (Q = 1, Qn = 0 を保持)");
        end else begin
            $display("✗ FAIL: テストケース1 - 期待値 Q = 1, Qn = 0, 取得値 Q = %b, Qn = %b", Q, Qn);
        end

        // テストケース2: リセット (R Low) S=1,R=0
        // 期待: Q=0, Qn=1
        S = 1; R = 0;
        #10;
        $display("テストケース2: S = %b, R = %b, Q = %b, Qn = %b", S, R, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) begin
            $display("✓ PASS: テストケース2 - リセット (Q = 0, Qn = 1)");
        end else begin
            $display("✗ FAIL: テストケース2 - 期待値 Q = 0, Qn = 1, 取得値 Q = %b, Qn = %b", Q, Qn);
        end

        // テストケース3: リセット後のホールド S=1,R=1
        // 期待: 直前のリセット結果 Q=0, Qn=1 を保持
        S = 1; R = 1;
        #10;
        $display("テストケース3: S = %b, R = %b, Q = %b, Qn = %b", S, R, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) begin
            $display("✓ PASS: テストケース3 - ホールド (Q = 0, Qn = 1 を保持)");
        end else begin
            $display("✗ FAIL: テストケース3 - 期待値 Q = 0, Qn = 1, 取得値 Q = %b, Qn = %b", Q, Qn);
        end

        // テストケース4: セット (S Low) S=0,R=1
        // 期待: Q=1, Qn=0
        S = 0; R = 1;
        #10;
        $display("テストケース4: S = %b, R = %b, Q = %b, Qn = %b", S, R, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) begin
            $display("✓ PASS: テストケース4 - セット (Q = 1, Qn = 0)");
        end else begin
            $display("✗ FAIL: テストケース4 - 期待値 Q = 1, Qn = 0, 取得値 Q = %b, Qn = %b", Q, Qn);
        end

        // テストケース5: 不正状態 (S=0,R=0 同時 Low)
        // NAND 型の SR ラッチでは両出力が 1 になり、実シリコンでは不定・禁止状態
        S = 0; R = 0;
        #10;
        $display("テストケース5: S = %b, R = %b, Q = %b, Qn = %b", S, R, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b1) begin
            $display("✓ PASS: テストケース5 - 不正状態を検出 (Q と Qn が同時に 1)");
        end else begin
            $display("✗ FAIL: テストケース5 - 期待値 Q = 1, Qn = 1 (不正状態), 取得値 Q = %b, Qn = %b", Q, Qn);
        end

        // シミュレーション終了
        $finish;
    end
endmodule
