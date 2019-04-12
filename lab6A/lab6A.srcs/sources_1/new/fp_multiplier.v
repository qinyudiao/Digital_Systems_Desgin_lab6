//from page 412 in book
module fp_multiplier(clk, St, F1, E1, F2, E2, F, V, done);
input clk;
input St;
input [3:0] F1;
input [3:0] E1;
input [3:0] F2;
input [3:0] E2;
output reg [6:0] F;
output reg V;   //overflow indicator
output reg done;    //floating point multiplication compelte

reg [3:0] A;
reg [3:0] B;
reg [3:0] C;
reg [4:0] X;
reg [4:0] Y;
reg Load;   //load F1, E1, F2, E2 to appropriate registers
reg Adx;    //add exponents, starts fraction multiplier
reg SM8;    //set exponent to -2 (handle special case of 0)
reg RSF;    //shift fraction right, increment E
reg LSF;    //shift fraction left, decrement E
reg AdSh;
reg Sh;
reg Cm;
reg Mdone;  //fraction multiply done
reg [1:0] PS1;
reg [1:0] NS1;
reg [2:0] State;
reg [2:0] Nextstate;

initial begin
    State = 0;
    PS1 = 0;
    NS1 = 0;
    Nextstate = 0;
end

//main always statement, generate control signals based on SM chart
always @(PS1 or St or Mdone or X or A or B) 
begin: main_control
    Load = 1'b0;
    Adx = 1'b0;
    NS1 = 0;
    SM8 = 1'b0;
    RSF = 1'b0;
    LSF = 1'b0;
    V = 1'b0;
    F = 7'b0000000;
    done = 1'b0;
    case(PS1)
        0:
            begin
                F = 7'b0000000; //initialize
                done = 1'b0;
                V = 1'b0;
                if(St == 1'b1)
                begin
                    Load = 1'b1;
                    NS1 = 1;
                end
            end
        1:
            begin
                Adx = 1'b1; //set flag to add
                NS1 = 2;
            end
        2:
            begin
                if(Mdone == 1'b1)   //check if fractino multiply done
                    begin
                        if(A == 0)  //special case of 0
                        begin
                            SM8 = 1'b1; //set exponent to -8 for special case of 0
                        end
                        else if (A == 4 & B == 0)
                        begin
                            RSF = 1'b1; //shift fraction right, increment exponent
                        end
                        else if (A[2] == A[1])
                        begin
                            LSF = 1'b1; //shift fraction left, decrement exponent
                        end
                        NS1 = 3;    //go to next state
                    end
                else
                    begin
                        NS1 = 2;    //keep staying at this state until fraction multiply done
                    end
            end
        3:
            begin
                if(X[4] != X[3])    //check for overflow
                    begin
                        V = 1'b1;
                    end
                else
                    begin
                        V = 1'b0;
                    end
                done = 1'b1;    //finished multiplication
                F = {A[2:0], B};    //set fraction
                if(St == 1'b0)  //reset statemachine if start signal low
                    begin
                        NS1 = 0;
                    end
            end
    endcase
end

//generates control signals for fraction multiplier
always @(State or Adx or B)
begin: mul2c
    AdSh = 1'b0;
    Sh = 1'b0;
    Cm = 1'b0;
    Mdone = 1'b0;
    Nextstate = 0;  //initialize
    case(State)
        0:
            begin
                if(Adx == 1'b1) //finished adding exponent, start multiply fraction
                begin
                    if((B[0]) == 1'b1)
                        begin
                            AdSh = 1'b1;
                        end
                    else
                        begin
                            Sh = 1'b1;
                        end
                    Nextstate = 1;
                end
            end
        1, 2:
            begin
                if((B[0]) == 1'b1)
                    begin
                        AdSh = 1'b1;
                    end
                else
                    begin
                        Sh = 1'b1;
                    end
                Nextstate = State + 1;
            end
        3: 
            begin
                if((B[0]) == 1'b1)
                    begin
                        Cm = 1'b1;
                        AdSh = 1'b1;
                    end
                else
                    begin
                        Sh = 1'b1;
                    end
                Nextstate = 4;
            end
        4: 
            begin
                Mdone = 1'b1;   //finish multiplying
                Nextstate = 0;  //restart state machine
            end
    endcase
end

wire [3:0] addout;  //represents output of 4 bit full adder for fraction multiplier
assign addout = (Cm == 1'b0)? (A+C) : (A-C);

//tests the control signals and updates the appropriate registers on rising edge of clock
always @(posedge clk)
begin : update
    PS1 <= NS1;
    State <= Nextstate;
    if(Load == 1'b1)
        begin
            X <= {E1[3], E1}; //sign extend exponent 1
            Y <= {E2[3], E2}; //sign extend exponent 2
            A <= 4'b0000;
            B <= F1;    //B = fraction 1
            C <= F2;    //C = fraction 2
        end
    if(Adx == 1'b1)
        begin
            X <= X+Y;   //add exponents
        end
    if(SM8 == 1'b1)
        begin
            X <= 5'b11000;
        end
    if(RSF == 1'b1) //shift fraction right, increment exponent
        begin
            A <= {1'b0, A[3:1]};
            B <= {A[0], B[3:1]};
            X <= X+1;
        end
    if(LSF == 1'b1) //shift fraction left, decrement exponent
        begin
            A <= {A[2:0], B[3]};
            B <= {B[2:0], 1'b0};
            X <= X+31;
        end
    if(AdSh == 1'b1)
        begin
            A <= {(C[3] ^ Cm), addout[3:1]};
            B <= {addout[0], B[3:1]};
        end
    if(Sh == 1'b1)
        begin
            A <= {A[3], A[3:1]};
            B <= {A[0], B[3:1]};
        end
    end
endmodule