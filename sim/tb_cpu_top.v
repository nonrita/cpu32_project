`timescale 1ns/1ps

module tb_cpu_top;
    reg CLK;
    reg RST;

    // DUT
    cpu_top uut (
        .CLK(CLK),
        .RST(RST)
    );

    // 20ns 周期クロック
    always #10 CLK = ~CLK;

    initial begin
        CLK = 1'b0;
        RST = 1'b1;

        // リセット期間
        repeat(2) @(posedge CLK);
        RST = 1'b0;

        $display("\n==== CPU Top Test with IMEM ====");
        $display("\nExecuting sample program:");
        $display("  [0] addi $2, $0, 5");
        $display("  [1] addi $3, $0, 3");
        $display("  [2] add  $1, $2, $3");
        $display("  [3] sub  $4, $2, $3");
        $display("  [4] and  $5, $2, $3");
        $display("  [5] or   $6, $2, $3");

        // プログラム実行を観測
        repeat(10) begin
            @(posedge CLK);
            #1;
            $display("\n---- Cycle @ PC=%h ----", uut.pc);
            $display("Instr  = %h", uut.instr);
            $display("rs=%d rt=%d rd=%d", uut.rs, uut.rt, uut.rd);
            $display("ALU: A=%d B=%d op=%d => Y=%d", uut.alu_a, uut.alu_b, uut.alu_op, uut.alu_result);
            $display("RF Write: we=%b addr=%d data=%d", uut.rf_we, uut.rf_waddr, uut.rf_wdata);
            
            // レジスタファイルの内容を表示
            if (uut.rf_we) begin
                $display("=> Reg[$%d] = %d", uut.rf_waddr, uut.rf_wdata);
            end
        end

        $display("\n---- Final Register State ----");
        $display("$1 = %d (expected: 8)", uut.u_regfile.reg_q[1]);
        $display("$2 = %d (expected: 5)", uut.u_regfile.reg_q[2]);
        $display("$3 = %d (expected: 3)", uut.u_regfile.reg_q[3]);
        $display("$4 = %d (expected: 2)", uut.u_regfile.reg_q[4]);
        $display("$5 = %d (expected: 1)", uut.u_regfile.reg_q[5]);
        $display("$6 = %d (expected: 7)", uut.u_regfile.reg_q[6]);

        $display("\n==== Test Complete ====\n");
        #10;
        $finish;
    end
endmodule
