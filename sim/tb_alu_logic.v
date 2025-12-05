`timescale 1ns/1ps
`include "alu_defs.vh"

module tb_alu_logic;
    reg  [31:0] A, B;
    wire [31:0] and_y, or_y, xor_y, not_y;

    and32 u_and (.A(A), .B(B), .Y(and_y));
    or32  u_or  (.A(A), .B(B), .Y(or_y));
    xor32 u_xor (.A(A), .B(B), .Y(xor_y));
    not32 u_not (.A(A),       .Y(not_y));

    initial begin
        A = 32'hA5A5_F00F;
        B = 32'h0F0F_0F0F;

        #1;
        $display("\n---- AND ----");
        $display("A=%h B=%h Y=%h", A, B, and_y);
        if (and_y === (A & B)) $display("✓ PASS AND"); else $display("✗ FAIL AND");

        $display("\n---- OR ----");
        $display("A=%h B=%h Y=%h", A, B, or_y);
        if (or_y === (A | B)) $display("✓ PASS OR"); else $display("✗ FAIL OR");

        $display("\n---- XOR ----");
        $display("A=%h B=%h Y=%h", A, B, xor_y);
        if (xor_y === (A ^ B)) $display("✓ PASS XOR"); else $display("✗ FAIL XOR");

        $display("\n---- NOT ----");
        $display("A=%h Y=%h", A, not_y);
        if (not_y === ~A) $display("✓ PASS NOT"); else $display("✗ FAIL NOT");

        #5; $finish;
    end
endmodule
