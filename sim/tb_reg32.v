`timescale 1ns/1ps

module tb_reg32;
    reg        CLK;
    reg        RST;
    reg [31:0] D;
    wire [31:0] Q;

    // DUT
    reg32 uut (
        .CLK(CLK),
        .RST(RST),
        .D(D),
        .Q(Q)
    );

    // 20ns 周期クロック
    always #10 CLK = ~CLK;

    initial begin
        CLK = 1'b0;
        RST = 1'b1;
        D   = 32'h0000_0000;

        // TC0: リセット中の初回立ち上がりでクリア
        @(posedge CLK); #1;
        $display("\n---- TC0 ----");
        $display("RST中 | RST=%b D=%h Q=%h", RST, D, Q);
        if (Q === 32'h0000_0000) $display("✓ PASS TC0 初期クリア");
        else $display("✗ FAIL TC0 期待 0000_0000 実測 %h", Q);

        // リセット解除
        RST = 1'b0;

        // TC1: パターン1を取り込む
        D = 32'hA5A5_F00D;
        @(posedge CLK); #1;
        $display("\n---- TC1 ----");
        $display("CLK↑で取り込み | D=%h Q=%h", D, Q);
        if (Q === 32'hA5A5_F00D) $display("✓ PASS TC1");
        else $display("✗ FAIL TC1 期待 A5A5_F00D 実測 %h", Q);

        // TC2: 次立ち上がりでパターン2を取り込む（High期間のD変化は保持されること）
        #2; D = 32'hDEAD_BEEF; // High期間で変更
        #6;                    // まだ次の立上り前
        $display("\n---- TC2-pre ----");
        $display("CLK High中変更 | 現Q=%h (保持期待)", Q);
        if (Q === 32'hA5A5_F00D) $display("✓ PASS TC2-pre 保持");
        else $display("✗ FAIL TC2-pre 期待 A5A5_F00D 実測 %h", Q);
        @(posedge CLK); #1;
        $display("\n---- TC2 ----");
        $display("CLK↑で取り込み | D=%h Q=%h", D, Q);
        if (Q === 32'hDEAD_BEEF) $display("✓ PASS TC2");
        else $display("✗ FAIL TC2 期待 DEAD_BEEF 実測 %h", Q);

        // TC3: 再リセットでクリア
        RST = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC3 ----");
        $display("同期リセット | RST=%b D=%h Q=%h", RST, D, Q);
        if (Q === 32'h0000_0000) $display("✓ PASS TC3 クリア");
        else $display("✗ FAIL TC3 期待 0000_0000 実測 %h", Q);
        RST = 1'b0;

        // TC4: パターン3を取り込む
        D = 32'h1234_5678;
        @(posedge CLK); #1;
        $display("\n---- TC4 ----");
        $display("CLK↑で取り込み | D=%h Q=%h", D, Q);
        if (Q === 32'h1234_5678) $display("✓ PASS TC4");
        else $display("✗ FAIL TC4 期待 1234_5678 実測 %h", Q);

        // 終了
        #10;
        $finish;
    end
endmodule
