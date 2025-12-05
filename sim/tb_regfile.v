`timescale 1ns/1ps

module tb_regfile;
    reg        CLK;
    reg        RST;
    reg        WE;
    reg [4:0]  WADDR;
    reg [31:0] WDATA;
    reg [4:0]  RADDR1;
    reg [4:0]  RADDR2;
    wire [31:0] RDATA1;
    wire [31:0] RDATA2;

    // DUT
    regfile uut (
        .CLK(CLK),
        .RST(RST),
        .WE(WE),
        .WADDR(WADDR),
        .WDATA(WDATA),
        .RADDR1(RADDR1),
        .RADDR2(RADDR2),
        .RDATA1(RDATA1),
        .RDATA2(RDATA2)
    );

    // 20ns 周期クロック
    always #10 CLK = ~CLK;

    initial begin
        CLK = 1'b0;
        RST = 1'b1;
        WE  = 1'b0;
        WADDR  = 5'd0;
        WDATA  = 32'h0000_0000;
        RADDR1 = 5'd0;
        RADDR2 = 5'd1;

        // TC0: リセットで全クリア
        @(posedge CLK); #1;
        $display("\n---- TC0 ----");
        $display("RST中 | RDATA1=%h RDATA2=%h", RDATA1, RDATA2);
        if (RDATA1 === 32'h0 && RDATA2 === 32'h0) $display("✓ PASS TC0 初期クリア");
        else $display("✗ FAIL TC0 期待 0/0 実測 %h/%h", RDATA1, RDATA2);

        // リセット解除
        RST = 1'b0;

        // TC1: アドレス3へ書き込みし、ポート1で即座に参照できるか
        WE = 1'b1; WADDR = 5'd3; WDATA = 32'hDEAD_BEEF;
        @(posedge CLK); #1; // 書き込み確定後に読み出し
        RADDR1 = 5'd3; RADDR2 = 5'd0;
        $display("\n---- TC1 ----");
        $display("Write A3=DEAD_BEEF | R1=%h R2=%h", RDATA1, RDATA2);
        if (RDATA1 === 32'hDEAD_BEEF && RDATA2 === 32'h0) $display("✓ PASS TC1");
        else $display("✗ FAIL TC1 期待 DEAD_BEEF/0 実測 %h/%h", RDATA1, RDATA2);

        // TC2: アドレス10へ別データ、ポート2で参照
        WADDR = 5'd10; WDATA = 32'hCAFEBABE;
        @(posedge CLK); #1;
        RADDR1 = 5'd3; RADDR2 = 5'd10;
        $display("\n---- TC2 ----");
        $display("Write A10=CAFEBABE | R1=%h R2=%h", RDATA1, RDATA2);
        if (RDATA1 === 32'hDEAD_BEEF && RDATA2 === 32'hCAFEBABE) $display("✓ PASS TC2");
        else $display("✗ FAIL TC2 期待 DEAD_BEEF/CAFEBABE 実測 %h/%h", RDATA1, RDATA2);

        // TC3: WE=0 のとき変更されないこと
        WE = 1'b0; WADDR = 5'd3; WDATA = 32'h1111_2222;
        @(posedge CLK); #1;
        $display("\n---- TC3 ----");
        $display("WE=0 no write | R1=%h R2=%h", RDATA1, RDATA2);
        if (RDATA1 === 32'hDEAD_BEEF && RDATA2 === 32'hCAFEBABE) $display("✓ PASS TC3");
        else $display("✗ FAIL TC3 期待 DEAD_BEEF/CAFEBABE 実測 %h/%h", RDATA1, RDATA2);

        // TC4: 同一アドレスを両ポートで読み、内容一致を確認
        RADDR1 = 5'd10; RADDR2 = 5'd10;
        #1;
        $display("\n---- TC4 ----");
        $display("Same addr read | R1=%h R2=%h", RDATA1, RDATA2);
        if (RDATA1 === 32'hCAFEBABE && RDATA2 === 32'hCAFEBABE) $display("✓ PASS TC4");
        else $display("✗ FAIL TC4 期待 CAFEBABE/CAFEBABE 実測 %h/%h", RDATA1, RDATA2);

        // TC5: 再リセットで全クリア
        RST = 1'b1; WE = 1'b0;
        @(posedge CLK); #1;
        RADDR1 = 5'd3; RADDR2 = 5'd10;
        $display("\n---- TC5 ----");
        $display("Reset again | R1=%h R2=%h", RDATA1, RDATA2);
        if (RDATA1 === 32'h0 && RDATA2 === 32'h0) $display("✓ PASS TC5");
        else $display("✗ FAIL TC5 期待 0/0 実測 %h/%h", RDATA1, RDATA2);

        // 終了
        #10;
        $finish;
    end
endmodule
