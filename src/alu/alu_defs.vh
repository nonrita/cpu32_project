`ifndef ALU_DEFS_VH
`define ALU_DEFS_VH

// 操作コード定義
`define ALU_OP_ADD   4'd0
`define ALU_OP_SUB   4'd1
`define ALU_OP_AND   4'd2
`define ALU_OP_OR    4'd3
`define ALU_OP_XOR   4'd4
`define ALU_OP_NOT   4'd5
`define ALU_OP_SLL   4'd6
`define ALU_OP_SRL   4'd7
`define ALU_OP_SRA   4'd8
`define ALU_OP_SLT   4'd9
`define ALU_OP_SLTU  4'd10

// フラグのビット位置
`define ALU_FLAG_Z 0 // Zero
`define ALU_FLAG_N 1 // Negative
`define ALU_FLAG_C 2 // Carry
`define ALU_FLAG_V 3 // Overflow

`endif // ALU_DEFS_VH
