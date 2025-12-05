`timescale 1ns/1ps
`include "alu_defs.vh"

// 簡易デコーダ: opcode/funct から ALU_OP を生成
module alu_ctrl (
    input  wire [5:0] opcode,
    input  wire [5:0] funct,
    output reg  [3:0] alu_op
);
    always @* begin
        case (opcode)
            6'b000000: begin // R-type
                case (funct)
                    6'b100000: alu_op = `ALU_OP_ADD;
                    6'b100010: alu_op = `ALU_OP_SUB;
                    6'b100100: alu_op = `ALU_OP_AND;
                    6'b100101: alu_op = `ALU_OP_OR;
                    6'b100110: alu_op = `ALU_OP_XOR;
                    6'b100111: alu_op = `ALU_OP_NOT; // NOR を NOT(A|B) で扱う前提
                    6'b000000: alu_op = `ALU_OP_SLL;
                    6'b000010: alu_op = `ALU_OP_SRL;
                    6'b000011: alu_op = `ALU_OP_SRA;
                    6'b101010: alu_op = `ALU_OP_SLT;
                    6'b101011: alu_op = `ALU_OP_SLTU;
                    default:   alu_op = `ALU_OP_ADD;
                endcase
            end
            // I-type の例
            6'b001000: alu_op = `ALU_OP_ADD;   // addi
            6'b001100: alu_op = `ALU_OP_AND;   // andi
            6'b001101: alu_op = `ALU_OP_OR;    // ori
            6'b001110: alu_op = `ALU_OP_XOR;   // xori
            6'b001010: alu_op = `ALU_OP_SLT;   // slti
            6'b001011: alu_op = `ALU_OP_SLTU;  // sltiu
            default:   alu_op = `ALU_OP_ADD;
        endcase
    end
endmodule
