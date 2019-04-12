module mac_operator(clk, value, inputA, inputB);
input clk;
output[7:0] value;
input[7:0] inputA;
input[7:0] inputB;

wire [3:0] Vexp = value[7:4];  //4 bit exponent
wire [3:0] Vfrac = value[3:0]; //4 bit fraction

wire Asign = inputA[7];
wire [3:0] Aexp = inputA[7:4];  //4 bit exponent
wire [3:0] Afrac = inputA[3:0]; //4 bit fraction

wire Bsign = inputB[7];
wire [3:0] Bexp = inputB[7:4];  //4 bit exponent
wire [3:0] Bfrac = inputB[3:0]; //4 bit fraction

reg St; //start flag output for mult
reg [6:0] F;    //output
reg done1;  //done flag
reg V;  //overflow flag

reg St2;    //start input for add
reg done2;  //done flag 2
reg ovf;    //overflow flag
reg unf;    //underflow flag
reg FPinput;    //floating point input
reg FPsum;  //floating point sum/output

multiply fp_multiplier(clk, St, Afrac, Aexp, Asign, Bfrac, Bexp, Bsign, F, V, done1);
add fp_adder(clk, done1, done2, ovf, unf, FPinput, FPsum);
endmodule
