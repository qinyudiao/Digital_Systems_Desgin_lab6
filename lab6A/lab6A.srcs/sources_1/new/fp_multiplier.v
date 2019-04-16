
module fp_multiplier(
    input [7:0] inA,    // First input
    input [7:0] inB,    // Second input
    output [7:0] outC  // Product
);

    // Extract fields of A and B.
    wire Asign;
    wire [2:0] Aexp;
    wire [3:0] Afrac;
    wire Bsign;
    wire [2:0] Bexp;
    wire [3:0] Bfrac;
    assign Asign = inA[7];
    assign Aexp = inA[6:4];
    assign Afrac = {1'b1, inA[3:1]};
    assign Bsign = inB[7];
    assign Bexp = inB[6:4];
    assign Bfrac = {1'b1, inB[3:1]};

    // XOR sign bits to determine product sign.
    wire outSign;
    assign outSign = Asign ^ Bsign;

    // Multiply the fractions of A and B
    wire [8:0] pre_prod_frac;
    assign pre_prod_frac = Afrac * Bfrac;

    // Add exponents of A and B
    wire [3:0]  pre_prod_exp;
    assign pre_prod_exp = Aexp + Bexp;

    // check for overflow, shift right if yes and normalize if no
    wire [2:0]  outExp;
    wire [3:0] outFrac;
    assign outExp = (pre_prod_frac > 4'b1111) ? (pre_prod_exp-2'd2) : (pre_prod_frac[8] ? (pre_prod_exp-3'd4) : (pre_prod_exp - 2'd3));
    assign outFrac = (pre_prod_frac > 4'b1111) ? {1'b0, pre_prod_frac[7:4]} : (pre_prod_frac[8] ? pre_prod_frac[7:3] : pre_prod_frac[6:2]); //shift bits if not leading 1

    // LSF: If top bit of product frac is 0, shift left one
    //    assign outExp = pre_prod_frac[8] ? (pre_prod_exp-3'd4) : (pre_prod_exp - 2'd3); //if not leading 1, only subtract 2 for bias, otherwise subtract 3
    //    assign outFrac = pre_prod_frac[8] ? pre_prod_frac[7:3] : pre_prod_frac[6:2]; //shift bits if not leading 1
    //    assign outExp = outFrac ? outExp : 4'b000; 

    // Detect underflow
    wire underflow;
    assign underflow = pre_prod_exp < 4'b1101; //check if exponent is less than -3

    // Detect zero conditions (either product frac doesn't start with 1, or underflow)
    assign outC = underflow         ? 8'b10000000 :
                  (Bexp == 3'd0)    ? 8'b10000000 :
                  (Aexp == 3'd0)    ? 8'b10000000 :
                  {outSign, outExp, outFrac};

endmodule