`timescale 1ns/1ps
`include "alu_defs.vh"

module tb_alu_shift;
    reg  [31:0] A;
    reg  [4:0]  SHAMT;
    reg  [1:0]  MODE;
    wire [31:0] Y;

    barrel_shifter uut (
        .A(A), .SHAMT(SHAMT), .MODE(MODE), .Y(Y)
    );

    task expect(input [31:0] exp, input [127:0] name);
        begin
            if (Y === exp) $display("✓ PASS %s", name);
            else $display("✗ FAIL %s exp=%h got=%h", name, exp, Y);
        end
    endtask

    initial begin
        A = 32'h8000_0001; SHAMT = 5'd1;

        // SLL
        MODE = 2'b00; #1;
        $display("\n---- SLL ----");
        expect(A << SHAMT, "SLL");

        // SRL
        MODE = 2'b01; #1;
        $display("\n---- SRL ----");
        expect(A >> SHAMT, "SRL");

        // SRA
        MODE = 2'b10; #1;
        $display("\n---- SRA ----");
        expect($signed(A) >>> SHAMT, "SRA");

        #5; $finish;
    end
endmodule
