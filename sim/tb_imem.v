`timescale 1ns/1ps

module tb_imem;
    reg  [31:0] addr;
    wire [31:0] instr;

    // インスタンス化
    imem uut (
        .addr(addr),
        .instr(instr)
    );

    initial begin
        $display("\n==== IMEM Test ====");
        
        $display("\n---- Reading Sample Program ----");
        
        // アドレス 0x00: addi $2, $0, 5
        addr = 32'h00000000;
        #10;
        $display("addr=%h => instr=%h (expected: 20020005)", addr, instr);
        
        // アドレス 0x04: addi $3, $0, 3
        addr = 32'h00000004;
        #10;
        $display("addr=%h => instr=%h (expected: 20030003)", addr, instr);
        
        // アドレス 0x08: add $1, $2, $3
        addr = 32'h00000008;
        #10;
        $display("addr=%h => instr=%h (expected: 00430820)", addr, instr);
        
        // アドレス 0x0C: sub $4, $2, $3
        addr = 32'h0000000C;
        #10;
        $display("addr=%h => instr=%h (expected: 00432022)", addr, instr);
        
        // アドレス 0x10: and $5, $2, $3
        addr = 32'h00000010;
        #10;
        $display("addr=%h => instr=%h (expected: 00432824)", addr, instr);
        
        // アドレス 0x14: or $6, $2, $3
        addr = 32'h00000014;
        #10;
        $display("addr=%h => instr=%h (expected: 00433025)", addr, instr);
        
        $display("\n---- Testing Uninitialized Area (should be NOP) ----");
        
        // アドレス 0x100: 未初期化領域
        addr = 32'h00000100;
        #10;
        $display("addr=%h => instr=%h (expected: 00000000 NOP)", addr, instr);
        
        $display("\n==== Test Complete ====\n");
        $finish;
    end

endmodule
