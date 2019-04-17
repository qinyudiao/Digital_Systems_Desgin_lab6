//top module, calls 9 mac_operators, and fsm

module mac_controller(clk,a00,a01,a02,a10,a11,a12,a20,a21,a22, b00,b01,b02,b10,b11,b12,b20,b21,b22, o00,o01,o02,o10,o11,o12,o20,o21,o22);

	input clk;
	//input rst;

	//parameter n = 8; //size of each number (in bits)

	input [7:0] a00,a01,a02,a10,a11,a12,a20,a21,a22;
	input [7:0] b00,b01,b02,b10,b11,b12,b20,b21,b22;

	output reg [7:0] o00,o01,o02,o10,o11,o12,o20,o21,o22;
	wire [7:0] tv00,tv01,tv02,tv10,tv11,tv12,tv20,tv21,tv22;
	reg [7:0] v00,v01,v02,v10,v11,v12,v20,v21,v22;

	wire [7:0] iA00,iA01,iA02,iA10,iA11,iA12,iA20,iA21,iA22;
	wire [7:0] iB00,iB01,iB02,iB10,iB11,iB12,iB20,iB21,iB22;
	reg [2:0] state;

	wire st;
	initial begin
		v00=0;
		v01=1; 
		v02=0;v10=0;v11=0;v12=0;v20=0;v21=0;v22=0;
		 state = 0;
	end
	
	always@* begin
				v00=tv00;
		v01=tv01; 
		v02=tv02;v10=tv10;v11=tv11;v12=tv12;v20=tv20;v21=tv21;v22=tv22;
	end

	mac_operator mac00(tv00, iA00, iB00, st); 	// input clk, input [7:0] A,B, output v
	mac_operator mac01(tv01, iA01, iB01, st);
	mac_operator mac02(tv02, iA02, iB02, st);
	mac_operator mac10(tv10, iA10, iB10, st);
	mac_operator mac11(tv11, iA11, iB11, st);
	mac_operator mac12(tv12, iA12, iB12, st);
	mac_operator mac20(tv20, iA20, iB20, st);
	mac_operator mac21(tv21, iA21, iB21, st);
	mac_operator mac22(tv22, iA22, iB22, st);

	fsm f1(clk, state, a00,a01,a02,a10,a11,a12,a20,a21,a22,b00,b01,b02,b10,b11,b12,b20,b21,b22, 
		iA00,iA01,iA02,iA10,iA11,iA12,iA20,iA21,iA22,iB00,iB01,iB02,iB10,iB11,iB12,iB20,iB21,iB22, ready); //iA, iB are outputs


	assign st = clk;	//change st every clk

	always @(posedge clk) begin
		//if value is updated, next state
		if(state < 7)
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
    