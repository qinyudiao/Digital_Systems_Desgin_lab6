//from page 421 in book
module fp_adder(clk, St, done, ovf, unf, FPinput, FPsum);
input clk;
input St;
output done;
output ovf;
output unf;
input[31:0] FPinput;
output[31:0] FPsum;

reg done;
reg ovf;
reg unf;

reg [25:0] F1;
reg [25:0] F2;
reg [7:0] E1;
reg [7:0] E2;
reg S1;
reg S2;
wire FV;
wire FU;
wire [27:0] F1comp;
wire [27:0] F2comp;
wire [27:0] Addout;
wire [27:0] Fsum;
reg [2:0] State;

initial begin
    State = 0;
    done = 0;
    ovf = 0;
    unf = 0;
    S1 = 0;
    S2 = 0;
    F1 = 0;
    F2 = 0;
    E1 = 0;
    E2 = 0;
end

assign F1comp = (S1 == 1'b1) ? ~({2'b00, F1}) + 1 : {2'b00, F1};
assign F2comp = (S2 == 1'b1) ? ~({2'b00, F2}) + 1 : {2'b00, F2};
assign Addout = F1comp + F2comp;
assign Fsum = ((Addout[27]) == 1'b0) ? Addout : ~Addout + 1;
assign FV = Fsum[27] ^ Fsum[26];
assign FU = ~F1[25];
assign FPsum = {S1, E1, F1[24:2]};

always @(posedge clk)begin
    case(State)
        0:
            begin
                if(St == 1'b1)
                    begin
                        E1 <= FPinput[30:23];
                        S1 <= FPinput[31];
                        F1[24:0] <= {FPinput[22:0], 2'b00};
                        if(FPinput == 0)
                            begin
                                F1[25] <= 1'b0;
                            end
                        else
                            begin
                                F1[25] <= 1'b1;
                            end
                        done <= 1'b0;
                        ovf <= 1'b0;
                        unf <= 1'b0;
                        State <= 1;
                    end
            end
        1:
            begin
                E2 <= FPinput[20:23];
                S2 <= FPinput[31];
                F2[24:0] <= {FPinput[22:0], 2'b00};
                if(FPinput == 0)
                    begin
                        F2[25] <= 1'b0;
                    end
                else
                    begin
                        F2[25] <= 1'b1;
                    end
                State <= 2;
            end
        2:
            begin
                if(F1 == 0 | F2 == 0)
                    begin
                        State <= 3;
                    end
                else
                    begin
                        if(E1 == E2)
                            begin
                                State <= 3;
                            end
                        else if (E1 < E2)
                            begin
                                F1 <= {1'b0, F1[25:1]};
                                E1 <= E1 + 1;
                            end
                        else
                            begin
                                F2 <= {1'b0, F2[25:1]};
                                E2 <= E2 + 1;
                            end
                    end
            end
        3:
            begin
                S1 <= Addout[27];
                if(FV == 1'b0)
                    begin
                        F1 <= Fsum[25:0];
                    end
                else
                    begin
                        F1 <= Fsum[26:1];
                        E1 <= E1 + 1;
                    end
                State <= 4;
            end
        4:
            begin
                if(F1 == 0)
                    begin
                        E1 <= 8'b00000000;
                        State <= 6;
                    end
                else
                    begin
                        State <= 5;
                    end
            end
        5:
            begin
                if(E1 == 0)
                    begin
                        unf <= 1'b1;
                        State <= 6;
                    end
                else if(FU == 1'b0)
                    begin
                        State <= 6;
                    end
                else
                    begin
                        F1 <= {F1[24:0], 1'b0};
                        E1 <= E1 - 1;
                    end
            end
        6:
            begin
                if(E1 == 255)
                    begin
                        ovf <= 1'b1;
                    end
                done <= 1'b1;
                State <= 0;
            end
    endcase
end
endmodule