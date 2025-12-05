`timescale 1ns/1ps

module tb_d_ff;
    reg D;
    reg CLK;
    reg RST;
    wire Q;
    wire Qn;

    // DUT: ポジティブエッジトリガ D-FF（同期リセット）
    d_ff uut (
        .D(D),
        .CLK(CLK),
        .RST(RST),
        .Q(Q),
        .Qn(Qn)
    );

    // 20ns 周期クロック
    always #10 CLK = ~CLK;

    initial begin
        // 初期化
        CLK = 1'b0;
        D   = 1'b0;
        RST = 1'b1;     // 同期リセットをかけておく

        // TC0: リセット中、最初の立ち上がりでクリアされる
        @(posedge CLK); #1;
        $display("\n---- TC0 ----");
        $display("RST中の立上り後 | RST=%b D=%b Q=%b Qn=%b", RST, D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS TC0 初期クリア"); else $display("✗ FAIL TC0 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);

        // リセット解除
        RST = 1'b0;

        // TC1: 次の立ち上がりで D=1 を取り込む
        D = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC1 ----");
        $display("CLK↑でD=1取り込み | D=%b Q=%b Qn=%b", D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS TC1"); else $display("✗ FAIL TC1 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);

        // TC2: CLK High 中に D=0 に変更（即反映しない）、次の立ち上がりで取り込む
        #2; D = 1'b0; #6;               // High 期間で変更
        $display("\n---- TC2-pre ----");
        $display("CLK High中変更 | D=%b Q=%b Qn=%b (保持期待)", D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS TC2-pre 保持"); else $display("✗ FAIL TC2-pre 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);
        @(posedge CLK); #1;
        $display("\n---- TC2 ----");
        $display("CLK↑でD=0取り込み | D=%b Q=%b Qn=%b", D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS TC2"); else $display("✗ FAIL TC2 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);

        // TC3: 同期リセットを High にして次の立ち上がりでクリア
        RST = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC3 ----");
        $display("同期リセット立上り | RST=%b D=%b Q=%b Qn=%b", RST, D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS TC3 リセットクリア"); else $display("✗ FAIL TC3 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);
        RST = 1'b0;

        // TC4: リセット解除後、D=1 を次の立ち上がりで取り込む
        D = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC4 ----");
        $display("リセット解除後 D=1 取り込み | D=%b Q=%b Qn=%b", D, Q, Qn);
        if (Q === 1'b1 && Qn === 1'b0) $display("✓ PASS TC4"); else $display("✗ FAIL TC4 期待 Q=1,Qn=0 実測 Q=%b,Qn=%b", Q, Qn);

        // TC5: High 期間に D=0 へ変更 → 次の立ち上がりで反映
        #2; D = 1'b0; #6;
        @(posedge CLK); #1;
        $display("\n---- TC5 ----");
        $display("次のCLK↑でD=0取り込み | D=%b Q=%b Qn=%b", D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS TC5"); else $display("✗ FAIL TC5 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);

        // TC6: 再リセット（同期）を確認
        RST = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC6 ----");
        $display("再リセット | RST=%b D=%b Q=%b Qn=%b", RST, D, Q, Qn);
        if (Q === 1'b0 && Qn === 1'b1) $display("✓ PASS TC6 リセット"); else $display("✗ FAIL TC6 期待 Q=0,Qn=1 実測 Q=%b,Qn=%b", Q, Qn);
        RST = 1'b0;

        // シミュレーション終了
        #5;
        $finish;
    end
endmodule
