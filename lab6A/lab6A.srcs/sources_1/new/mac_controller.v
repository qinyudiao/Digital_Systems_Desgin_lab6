//top module, calls 9 mac_operators, and fsm

module mac_controller(clk,a00,a01,a02,a10,a11,a12,a20,a21,a22, b00,b01,b02,b10,b11,b12,b20,b21,b22, o00,o01,o02,o10,o11,o12,o20,o21,o22);

	input clk;
	//input rst;

	parameter n = 8; //size of each number (in bits)

	input [n-1:0] a00,a01,a02,a10,a11,a12,a20,a21,a22;
	input [n-1:0] b00,b01,b02,b10,b11,b12,b20,b21,b22;

	output reg [n-1:0] o00,o01,o02,o10,o11,o12,o20,o21,o22;
	wire [n-1:0] v00,v01,v02,v10,v11,v12,v20,v21,v22;

	wire [n-1:0] iA [0:8];
	wire [n-1:0] iB [0:8];
	reg [2:0] state; 

	wire st;

	initial state = 0;

	mac_operator mac00(v00, iA[0], iB[0], st); 	// input clk, input [7:0] A,B, output v
	mac_operator mac01(v01, iA[1], iB[1], st);
	mac_operator mac02(v02, iA[2], iB[2], st);
	mac_operator mac10(v10, iA[3], iB[3], st);
	mac_operator mac11(v11, iA[4], iB[4], st);
	mac_operator mac12(v12, iA[5], iB[5], st);
	mac_operator mac20(v20, iA[6], iB[6], st);
	mac_operator mac21(v21, iA[7], iB[7], st);
	mac_operator mac22(v22, iA[8], iB[8], st);

	fsm f1(clk, state, a00,a01,a02,a10,a11,a12,a20,a21,a22,b00,b01,b02,b10,b11,b12,b20,b21,b22, iA[0],
			iA[1],iA[2],iA[3],iA[4],iA[5],iA[6],iA[7],iA[8],iB[0],iB[1],iB[2],iB[3],iB[4],iB[5],iB[6],iB[7],iB[8], ready); //iA, iB are outputs


	assign st = clk;	//change st every clk

	always @(v00,v01,v02,v10,v11,v12,v20,v21,v22) begin
		//if value is updated, next state
		if(state <= 7)
			state <= state+1;
		else
			state <= state;

	/*	if(rst == 1)
			state <= 0;
		else 	
			state <= state;*/
	end

	always @(posedge clk) begin
		//if detect ready signal, push v to o
		if(ready == 1) begin
			o00<=v00;o01<=v01;o02<=v02;o10<=v10;o11<=v11;o12<=v12;o20<=v20;o21<=v21;o22<=v22;
			end
		else	begin
			o00<=o00;o01<=o01;o02<=o02;o10<=o10;o11<=o11;o12<=o12;o20<=o20;o21<=o21;o22<=o22;
		end



	end

endmodule
    