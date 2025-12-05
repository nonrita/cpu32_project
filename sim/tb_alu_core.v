`timescale 1ns/1ps
`include "alu_defs.vh"

module tb_alu_core;
    reg  [31:0] A, B;
    reg  [3:0]  alu_op;
    reg  [31:0] tmp;
    wire [31:0] Y;
    wire [3:0]  FLAGS;

    alu_core uut (
        .A(A), .B(B), .alu_op(alu_op),
        .Y(Y), .FLAGS(FLAGS)
    );

    task expect(input [31:0] exp_y, input exp_z, input exp_n, input exp_c, input exp_v, input [127:0] name);
        begin
            if (Y === exp_y && FLAGS[`ALU_FLAG_Z]==exp_z && FLAGS[`ALU_FLAG_N]==exp_n && FLAGS[`ALU_FLAG_C]==exp_c && FLAGS[`ALU_FLAG_V]==exp_v)
                $display("✓ PASS %s", name);
            else
                $display("✗ FAIL %s expY=%h Z/N/C/V=%b/%b/%b/%b gotY=%h Z/N/C/V=%b/%b/%b/%b",
                         name, exp_y, exp_z, exp_n, exp_c, exp_v, Y,
                         FLAGS[`ALU_FLAG_Z], FLAGS[`ALU_FLAG_N], FLAGS[`ALU_FLAG_C], FLAGS[`ALU_FLAG_V]);
        end
    endtask

    initial begin
        // ADD
        A=32'h0000_0001; B=32'h0000_0002; alu_op=`ALU_OP_ADD; #1;
        $display("\n---- ADD ----");
        expect(32'h0000_0003, 1'b0, 1'b0, 1'b0, 1'b0, "ADD");

        // SUB
        A=32'h0000_0003; B=32'h0000_0004; alu_op=`ALU_OP_SUB; #1;
        $display("\n---- SUB ----");
        expect(32'hFFFF_FFFF, 1'b0, 1'b1, 1'b0, 1'b0, "SUB");

        // AND
        A=32'hFF00_FF00; B=32'h0F0F_0F0F; alu_op=`ALU_OP_AND; #1;
        $display("\n---- AND ----");
        tmp = A & B;
        expect(tmp, (tmp==0), tmp[31], 1'b0, 1'b0, "AND");

        // OR
        alu_op=`ALU_OP_OR; #1;
        $display("\n---- OR ----");
        tmp = A | B;
        expect(tmp, (tmp==0), tmp[31], 1'b0, 1'b0, "OR");

        // XOR
        alu_op=`ALU_OP_XOR; #1;
        $display("\n---- XOR ----");
        tmp = A ^ B;
        expect(tmp, (tmp==0), tmp[31], 1'b0, 1'b0, "XOR");

        // NOT (NOR)
        alu_op=`ALU_OP_NOT; #1;
        $display("\n---- NOT(NOR) ----");
        tmp = ~(A | B);
        expect(tmp, (tmp==0), tmp[31], 1'b0, 1'b0, "NOT");

        // SLL
        A=32'h0000_0001; B=32'h0000_0004; alu_op=`ALU_OP_SLL; #1;
        $display("\n---- SLL ----");
        expect(32'h0000_0010, 1'b0, 1'b0, 1'b0, 1'b0, "SLL");

        // SRL
        alu_op=`ALU_OP_SRL; #1;
        $display("\n---- SRL ----");
        expect(32'h0000_0000, 1'b1, 1'b0, 1'b0, 1'b0, "SRL");

        // SRA
        A=32'h8000_0000; B=32'h0000_0001; alu_op=`ALU_OP_SRA; #1;
        $display("\n---- SRA ----");
        expect(32'hC000_0000, 1'b0, 1'b1, 1'b0, 1'b0, "SRA");

        // SLT signed (A<B)
        A=32'hFFFF_FFFF; B=32'h0000_0001; alu_op=`ALU_OP_SLT; #1;
        $display("\n---- SLT ----");
        expect(32'h0000_0001, 1'b0, 1'b0, 1'b0, 1'b0, "SLT");

        // SLTU unsigned (A>B)
        A=32'hFFFF_FFFF; B=32'h0000_0001; alu_op=`ALU_OP_SLTU; #1;
        $display("\n---- SLTU ----");
        expect(32'h0000_0000, 1'b1, 1'b0, 1'b0, 1'b0, "SLTU");

        #5; $finish;
    end
endmodule
