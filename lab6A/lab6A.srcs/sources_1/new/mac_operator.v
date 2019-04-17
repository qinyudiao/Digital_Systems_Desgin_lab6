module mac_operator(value, inputB, inputC, rst);
input rst;
output[7:0] value;
input[7:0] inputB;
input[7:0] inputC;

//wire [3:0] Vexp = value[6:4];  //3 bit exponent
//wire [4:0] Vfrac = value[3:0]; //4 bit fraction

//wire Asign = inputA[7];
//wire [3:0] Aexp = inputA[7:4];  //4 bit exponent
//wire [4:0] Afrac = inputA[3:0]; //4 bit fraction

//wire Bsign = inputB[7];
//wire [3:0] Bexp = inputB[6:4];  //3 bit exponent
//wire [4:0] Bfrac = inputB[3:0]; //4 bit fraction

//reg St; //start flag output for mult
reg [7:0] pre_value;
reg [7:0] first_pre_value; //copy the pre_value and stop cur_value upadating as pre_value changes
reg counter;
wire [7:0] cur_value;
//reg done1;  //done flag
//reg V;  //overflow flag


//reg St2;    //start input for add
//reg done2;  //done flag 2
//reg ovf;    //overflow flag
//reg unf;    //underflow flag
//reg FPinput;    //floating point input
wire [7:0] FPprod;  //floating point sum/output

//multiply fp_multiplier(clk, St, Afrac, Aexp, Bfrac, Bexp, F, V, done1);
initial begin
	pre_value = 0;
	counter = 0;
end

fp_multiplier m1(inputB, inputC, FPprod);
fp_adder f2(FPprod, first_pre_value, cur_value);

assign value = cur_value;

always @ (posedge rst)
	begin
		if(counter == 0) begin
			first_pre_value = pre_value;
			counter = 1;
		end
		else begin
			first_pre_value = first_pre_value;
		end
	end

always @ (posedge rst)
	begin
			counter = 0;
	end

always @ (cur_value)
	begin
			pre_value = cur_value;
	end

endmodule
