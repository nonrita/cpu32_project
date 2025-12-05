`timescale 1ns/1ps
`include "alu_defs.vh"

module tb_alu_adder;
    reg  [31:0] A, B;
    reg         sub;
    wire [31:0] SUM;
    wire        CARRY_OUT;
    wire        OVERFLOW;

    adder32 uut (
        .A(A), .B(B), .sub(sub),
        .SUM(SUM), .CARRY_OUT(CARRY_OUT), .OVERFLOW(OVERFLOW)
    );

    task check(input [31:0] exp_sum, input exp_c, input exp_v, input [127:0] name);
        begin
            if (SUM === exp_sum && CARRY_OUT === exp_c && OVERFLOW === exp_v)
                $display("✓ PASS %s", name);
            else
                $display("✗ FAIL %s exp=%h c=%b v=%b got=%h c=%b v=%b", name, exp_sum, exp_c, exp_v, SUM, CARRY_OUT, OVERFLOW);
        end
    endtask

    initial begin
        // ADD no overflow
        A=32'h0000_0001; B=32'h0000_0002; sub=0; #1;
        $display("\n---- ADD1 ----");
        check(32'h0000_0003, 1'b0, 1'b0, "ADD1");

        // ADD unsigned carry
        A=32'hFFFF_FFFF; B=32'h0000_0001; sub=0; #1;
        $display("\n---- ADD2 ----");
        check(32'h0000_0000, 1'b1, 1'b0, "ADD2");

        // ADD signed overflow
        A=32'h7FFF_FFFF; B=32'h0000_0001; sub=0; #1;
        $display("\n---- ADD_OVF ----");
        check(32'h8000_0000, 1'b0, 1'b1, "ADD_OVF");

        // SUB basic
        A=32'h0000_0003; B=32'h0000_0001; sub=1; #1;
        $display("\n---- SUB1 ----");
        check(32'h0000_0002, 1'b1, 1'b0, "SUB1");

        // SUB borrow (carry_out=0)
        A=32'h0000_0000; B=32'h0000_0001; sub=1; #1;
        $display("\n---- SUB_BORR ----");
        check(32'hFFFF_FFFF, 1'b0, 1'b0, "SUB_BORR");

        // SUB case: negative minus negative (no overflow expected here)
        A=32'h8000_0000; B=32'hFFFF_FFFF; sub=1; #1;
        $display("\n---- SUB_NEG_NEG ----");
        check(32'h8000_0001, 1'b0, 1'b0, "SUB_NEG_NEG");

        #5; $finish;
    end
endmodule
