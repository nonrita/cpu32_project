`timescale 1ns/1ps

module sr_latch (
    input  wire S,
    input  wire R,
    output wire Q,
    output wire Qn
);
    // クロスカップルした NAND で構成した SR ラッチ
    // Q  = ~(S & Qn)
    // Qn = ~(R & Q)
    assign Q  = ~(S & Qn);
    assign Qn = ~(R & Q);
endmodule