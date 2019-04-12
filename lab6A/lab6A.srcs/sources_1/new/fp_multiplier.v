//from page 412 in book
module fp_multiplier(clk, St, F1, E1, S1, F2, E2, S2, F, V, done);
input clk;
input St;
input [3:0] F1;
input [2:0] E1;
input S1;
input [3:0] F2;
input [2:0] E2;
input S2;
output wire [7:0] F;
output reg V;   //overflow indicator
output reg done;    //floating point multiplication compelte

reg [3:0] Afrac;
reg [3:0] Bfrac;
reg [2:0] Aexp;
reg [2:0] Bexp;
reg [3:0] outFrac;
reg [2:0] outExp;
reg outSign;

reg [4:0] expAdd; //5 bit to check for overflow

assign F = {outExp, outFrac};

reg Adx;    //add exponents, starts fraction multiplier
reg SM8;    //set exponent to -2 (handle special case of 0)
reg RSF;    //shift fraction right, increment E
reg LSF;    //shift fraction left, decrement E
reg Mdone;  //fraction multiply done
reg [2:0] State;
reg [2:0] Nextstate;

initial begin
    Afrac <= F1>>1; //shift fraction over 1 to make room for leading 1
    Bfrac <= F2>>1;
    Aexp <= E1;
    Bexp <= E2;
    Adx <= 0;
    SM8 <= 0;
    RSF <= 0;
    LSF <= 0;
    State <= 0;
    Nextstate <= 0;
    outExp <= 0;
    outFrac <= 0;
    outSign <= S1^S2;
end

always@(*)begin
    case(State)
        0: if(St == 1)begin //initialize
            Afrac[3] = 1'b1;
            Bfrac[3] = 1'b1;  //set implied 1 for fraction
            
            if(Aexp > 3'b100)begin  //if the exponent is greater than 4
                Aexp = Aexp - 3'b011;  //subtract bias (3) from exponent
            end
            else begin
                
            end
            if(Bexp > 3'b100)begin  //if the exponent is greater than 4
                Bexp = Bexp - 3'b011;  //subtract bias (3) from exponent
            end
            else begin
                
            end
            expAdd = Aexp + Bexp; //add exponents
            
            if((S1^S2) == 1)begin //if only one number is negative
                if(S1 == 1)begin //F1 is negative
                    Afrac = ~(Afrac - 1);
                end
                else if(S2 == 1)begin //F2 is negative
                    Bfrac = ~(Bfrac - 1);
                end
            end
            outFrac = Afrac * Bfrac; //multiply fractions
            
            if(outFrac == 4'b0000)begin
                SM8 <= 1;   //set flag for 0 case
            end
            Nextstate = 1;
        end
    endcase
end

always@(Nextstate)begin //update state
    State<=Nextstate;
end
endmodule