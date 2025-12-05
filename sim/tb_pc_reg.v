`timescale 1ns/1ps

module tb_pc_reg;
    reg        CLK;
    reg        RST;
    reg        PC_EN;
    reg [31:0] PC_NEXT;
    wire [31:0] PC;

    // DUT
    pc_reg uut (
        .CLK(CLK),
        .RST(RST),
        .PC_EN(PC_EN),
        .PC_NEXT(PC_NEXT),
        .PC(PC)
    );

    // 20ns 周期クロック
    always #10 CLK = ~CLK;

    initial begin
        CLK = 1'b0;
        RST = 1'b1;
        PC_EN = 1'b0;
        PC_NEXT = 32'h0000_0000;

        // TC0: リセット中の初回立ち上がりで PC = 0
        @(posedge CLK); #1;
        $display("\n---- TC0 ----");
        $display("RST中 | PC=%h", PC);
        if (PC === 32'h0000_0000) $display("✓ PASS TC0 初期値"); else $display("✗ FAIL TC0 期待 0 実測 %h", PC);

        // リセット解除
        RST = 1'b0;

        // TC1: PC_EN=1 で次の値をラッチ
        PC_NEXT = 32'h0000_0004;
        PC_EN = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC1 ----");
        $display("PC_EN=1 PC_NEXT=%h | PC=%h", PC_NEXT, PC);
        if (PC === 32'h0000_0004) $display("✓ PASS TC1"); else $display("✗ FAIL TC1 期待 0000_0004 実測 %h", PC);

        // TC2: PC_EN=1 で次々と更新
        PC_NEXT = 32'h0000_0008;
        @(posedge CLK); #1;
        $display("\n---- TC2 ----");
        $display("PC_NEXT=%h | PC=%h", PC_NEXT, PC);
        if (PC === 32'h0000_0008) $display("✓ PASS TC2"); else $display("✗ FAIL TC2 期待 0000_0008 実測 %h", PC);

        // TC3: PC_EN=0 のとき値が変わらない
        PC_NEXT = 32'hDEAD_BEEF;
        PC_EN = 1'b0;
        @(posedge CLK); #1;
        $display("\n---- TC3 ----");
        $display("PC_EN=0 PC_NEXT=%h | PC=%h (保持期待)", PC_NEXT, PC);
        if (PC === 32'h0000_0008) $display("✓ PASS TC3 保持"); else $display("✗ FAIL TC3 期待 0000_0008 実測 %h", PC);

        // TC4: 再度 PC_EN=1 で更新
        PC_EN = 1'b1;
        PC_NEXT = 32'h1000_0000;
        @(posedge CLK); #1;
        $display("\n---- TC4 ----");
        $display("PC_EN=1 PC_NEXT=%h | PC=%h", PC_NEXT, PC);
        if (PC === 32'h1000_0000) $display("✓ PASS TC4"); else $display("✗ FAIL TC4 期待 1000_0000 実測 %h", PC);

        // TC5: 再リセット
        RST = 1'b1;
        @(posedge CLK); #1;
        $display("\n---- TC5 ----");
        $display("Reset again | PC=%h", PC);
        if (PC === 32'h0000_0000) $display("✓ PASS TC5"); else $display("✗ FAIL TC5 期待 0 実測 %h", PC);

        // 終了
        #10;
        $finish;
    end
endmodule
