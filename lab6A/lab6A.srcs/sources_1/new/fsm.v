module fsm(clk, _state, a00,a01,a02,a10,a11,a12,a20,a21,a22,b00,b01,b02,b10,b11,b12,b20,b21,b22,
			iA00,iA01,iA02,iA10,iA11,iA12,iA20,iA21,iA22,iB00,iB01,iB02,iB10,iB11,iB12,iB20,iB21,iB22,ready);

	input clk;
	input [2:0] _state;
	input [7:0] a00,a01,a02,a10,a11,a12,a20,a21,a22;
	input [7:0] b00,b01,b02,b10,b11,b12,b20,b21,b22;

	
	reg [7:0] iA [0:8];
	reg [7:0] iB [0:8];
	output [7:0] iA00,iA01,iA02,iA10,iA11,iA12,iA20,iA21,iA22;
	output [7:0] iB00,iB01,iB02,iB10,iB11,iB12,iB20,iB21,iB22;
	output reg ready;
	
	initial begin
				iA[0] = 0;
				iB[0] = 0;
				iA[1] = 0;
				iB[1] = 0;
				iA[2] = 0;
				iB[2] = 0;
				iA[3] = 0;
				iB[3] = 0;
				iA[4] = 0;
				iB[4] = 0;
				iA[5] = 0;
				iB[5] = 0;
				iA[6] = 0;
				iB[6] = 0;
				iA[7] = 0;
				iB[7] = 0;
				iA[8] = 0;
				iB[8] = 0;
	end


	assign iA00 = iA[0];	
	assign iA01 = iA[1];
	assign iA02 = iA[2];
	assign iA10 = iA[3];
	assign iA11 = iA[4];
	assign iA12 = iA[5];
	assign iA20 = iA[6];
	assign iA21 = iA[7];
	assign iA22 = iA[8];
	assign iB00 = iB[0];	
	assign iB01 = iB[1];
	assign iB02 = iB[2];
	assign iB10 = iB[3];
	assign iB11 = iB[4];
	assign iB12 = iB[5];
	assign iB20 = iB[6];
	assign iB21 = iB[7];
	assign iB22 = iB[8];
	
	always @(posedge clk) begin
		case(_state)
		3'b000:	//cycle 1 : 0 - all else
			begin
				iA[0] = a00;
				iB[0] = b00;
				iA[1] = 0;
				iB[1] = 0;
				iA[2] = 0;
				iB[2] = 0;
				iA[3] = 0;
				iB[3] = 0;
				iA[4] = 0;
				iB[4] = 0;
				iA[5] = 0;
				iB[5] = 0;
				iA[6] = 0;
				iB[6] = 0;
				iA[7] = 0;
				iB[7] = 0;
				iA[8] = 0;
				iB[8] = 0;
				ready = 0;
			end
		3'b001: //cycle 2 : 0,1,3
			begin
				/*iA[0] = 1;
				iB[0] = 0;
				iA[1] = 0;
				iB[1] = 0;
				iA[3] = 0;
				iB[3] = 0;*/
				iA[0] = a01;
				iB[0] = b10;
				iA[1] = a00;
				iB[1] = b01;
				iA[3] = a10;
				iB[3] = b00;
			end
		3'b010: //cylce 3 : 0,1,2,3,4,6
			begin
				iA[0] = a02;
				iB[0] = b20;
				iA[1] = a01;
				iB[1] = b11;
				iA[2] = a00;
				iB[2] = b02;
				iA[3] = a11;
				iB[3] = b10;
				iA[4] = a10;
				iB[4] = b01;
				iA[6] = a20;
				iB[6] = b00;
			end		
		3'b011: //cylce 4 1,2,3,4,5,6,7 - 0
			begin
				iA[0] = 0;
				iB[0] = 0;
				iA[1] = a02;
				iB[1] = b21;
				iA[2] = a01;
				iB[2] = b12;
				iA[3] = a12;
				iB[3] = b20;
				iA[4] = a11;
				iB[4] = b11;
				iA[5] = a10;
				iB[5] = b02;
				iA[6] = a21;
				iB[6] = b10;
				iA[7] = a20;
				iB[7] = b01;
			end
		3'b100: //cylce 5 2,4,5,6,7,8 - 1,3
			begin
				iA[1] = 0;
				iB[1] = 0;
				iA[3] = 0;
				iB[3] = 0;
				iA[2] = a02;
				iB[2] = b22;
				iA[4] = a12;
				iB[4] = b21;
				iA[5] = a11;
				iB[5] = b12;
				iA[6] = a22;
				iB[6] = b20;
				iA[7] = a21;
				iB[7] = b11;
				iA[8] = a20;
				iB[8] = b02;
			end
		3'b101: //cycle 6 5,7,8 - 2,4,6	
			begin
				iA[2] = 0;
				iB[2] = 0;
				iA[4] = 0;
				iB[4] = 0;
				iA[6] = 0;
				iB[6] = 0;
				iA[5] = a12;
				iB[5] = b22;
				iA[7] = a22;
				iB[7] = b21;
				iA[8] = a21;
				iB[8] = b12;
			end
		3'b110: //cycle 7 8 - 5,7
			begin
				iA[5] = 0;
				iB[5] = 0;
				iA[7] = 0;
				iB[7] = 0;
				iA[8] = a22;
				iB[8] = b22;
				ready = 1;
			end
		3'b110: //cycle 8 - 8
			begin
				iA[8] = 0;
				iB[8] = 0;
				ready = 1;
			end
		default:
			begin
				iA[0] = 0;
				iB[0] = 0;
				iA[1] = 0;
				iB[1] = 0;
				iA[2] = 0;
				iB[2] = 0;
				iA[3] = 0;
				iB[3] = 0;
				iA[4] = 0;
				iB[4] = 0;
				iA[5] = 0;
				iB[5] = 0;
				iA[6] = 0;
				iB[6] = 0;
				iA[7] = 0;
				iB[7] = 0;
				iA[8] = 0;
				iB[8] = 0;
				ready = 0;
			end
		endcase
	end


endmodule
