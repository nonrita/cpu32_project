`timescale 1ns/1ps

// 命令メモリ（ROM）
// 1024 ワード（4KB）の命令格納領域
module imem (
    input  wire [31:0] addr,      // バイトアドレス
    output wire [31:0] instr      // 読み出し命令
);
    reg [31:0] mem [0:1023];      // 1024 ワード分のメモリ

    // 初期化: hex ファイルから読み込み、または直接初期化
    integer i;
    initial begin
        // デフォルトは全て NOP で埋める
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'h00000000;  // NOP
        end

        // サンプルプログラム（直接記述版）
        // addi $2, $0, 5    # $2 = 5
        mem[0] = 32'h20020005;
        // addi $3, $0, 3    # $3 = 3
        mem[1] = 32'h20030003;
        // add  $1, $2, $3   # $1 = $2 + $3 = 8
        mem[2] = 32'h00430820;
        // sub  $4, $2, $3   # $4 = $2 - $3 = 2
        mem[3] = 32'h00432022;
        // and  $5, $2, $3   # $5 = $2 & $3
        mem[4] = 32'h00432824;
        // or   $6, $2, $3   # $6 = $2 | $3
        mem[5] = 32'h00433025;

        // hex ファイルから読み込む場合（コメント外せば有効）
        // $readmemh("program.hex", mem);
    end

    // ワードアドレスに変換して読み出し（addr[31:2] を使用）
    assign instr = mem[addr[11:2]];  // 12ビット = 1024 ワード

endmodule
