`timescale 1ns / 1ps

module mult_tb;
    //inputs
    reg [7:0] inA = 8'b01010100;
    reg [7:0] inB = 8'b10110000;
    //outputs
    wire [7:0] outC;
    
    fp_multiplier uut(
        .inA(inA),
        .inB(inB),
        .outC(outC)
    );
endmodule
