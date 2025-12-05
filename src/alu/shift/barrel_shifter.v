`timescale 1ns/1ps

// mode: 2'b00=SLL, 01=SRL, 10=SRA
module barrel_shifter (
    input  wire [31:0] A,
    input  wire [4:0]  SHAMT,
    input  wire [1:0]  MODE,
    output reg  [31:0] Y
);
    always @* begin
        case (MODE)
            2'b00: Y = A << SHAMT;             // SLL
            2'b01: Y = A >> SHAMT;             // SRL
            2'b10: Y = $signed(A) >>> SHAMT;   // SRA
            default: Y = 32'b0;
        endcase
    end
endmodule
