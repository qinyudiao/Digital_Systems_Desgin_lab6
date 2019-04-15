/*Floating Point Adder*/
/*
1. determine the big and smaller number (absolute) by comparing exponential first and then fractional
2. get the difference between two numbers to shift the smaller number right
3. add the implied 1 to the two fraction numbers (big_frac, small_frac) and 2's complement the smaller number
4. add two floating number together, if sum[5]&two_comp is 1, select sum[4:1] and discard sum[0]
5. increase the temp_ex if sum[5]&two_comp is 1, and decrease if !sum[5]&!two_comp is 1 
								(result frac needs to shift left ex. 110-011 = 011)
6. assign results to temp_result, shift sum left and select sum[3:0] if !sum[5]&!two_comp is 1
7. check if a zero occurs select the result
*/
/**/
module fp_adder(num1, num2, result); //module fp_adder(num1, num2, result, overflow);
  input [7:0] num1, num2;
  output [7:0] result;
  //output overflow;
  reg [7:0] big_num, small_num; //to seperate big and small numbers 8-bit (absolute number)
  wire [3:0] big_frac, small_frac; //to hold fraction part, 4-bit
  wire [2:0] big_ex, small_ex; //to hold exponent part, 3-bit
  wire [3:0] temp_ex;
  wire big_sig, small_sig; // signs for
  reg two_comp; // 0 = 2's complement activated
  reg [1:0] zero; // 0->nonzero, 1->num1==0, 2->num2==0
  wire [7:0] temp_result;
  wire [4:0] big_float, small_float; //to hold as float number with implied 1
  reg [4:0] sign_small_float, shifted_small_float; //preparing small float
  wire [2:0] ex_diff; //difrence between exponentials ; 2^3; largest diff is 4-(-3)= 7, but shift larger than 4 will be ignored (underflow)
  wire [5:0] sum; //sum of numbers with integer parts
  
  initial 
	two_comp = 1; //2's complement activated indicates a subtraction, 

  //assign overflow = (big_sig & small_sig) & ((&big_ex) & (&small_ex)) & sum[5];
  assign temp_result[7] = big_sig; //result sign same as big sign
  assign temp_result[6:4] = temp_ex[2:0]; //get result exponent from temp_ex
  assign temp_result[3:0] = (sum[5]&two_comp) ? sum[4:1] : (((!sum[4])&(!two_comp)) ? {sum[2:0],1'b0} : sum[3:0]);

  assign result = (zero[1]) ? (zero[0] ? temp_result : num1) : (zero[0] ? num2 : temp_result); // if num2==0, result==num1...
  //decode numbers
  assign {big_sig, big_ex, big_frac} = big_num;
  assign {small_sig, small_ex, small_frac} = small_num;
  //add integer parts
  assign big_float = {1'b1, big_frac};
  assign small_float = {1'b1, small_frac};
  assign ex_diff = big_ex - small_ex; //diffrence between exponents
  assign sum = sign_small_float + big_float; //add numbers

  /*increase exponent if sum[5]=1 -> shifted left*/
  /*decrease exponent if sum[4]=0 and 2's complement executed -> shifted right*/
  assign temp_ex = (sum[5]&two_comp) ? (big_ex + 3'b1) : (((!sum[4])&(!two_comp)) ? (big_ex - 3'b1) : big_ex);

  always@* //shift small number to exponent of big number
    begin
      case (ex_diff)
        0: shifted_small_float = small_float;
        1: shifted_small_float = (small_float >> 1);
        2: shifted_small_float = (small_float >> 2);
        3: shifted_small_float = (small_float >> 3);
        4: shifted_small_float = (small_float >> 4);
        5: shifted_small_float = (small_float >> 5);
        6: shifted_small_float = (small_float >> 6);
        7: shifted_small_float = (small_float >> 7);
        default: shifted_small_float = 5'b0;
      endcase
    end

  always@* //if signs are diffrent take 2s compliment of small number
    begin
      if(big_sig != small_sig)
        begin
          sign_small_float = ~shifted_small_float + 5'b1;
	  two_comp = 0;
        end
      else
        begin
          sign_small_float = shifted_small_float;
        end
    end

  always@* //check zero
    begin
      if(num1 == 8'b00000000 | num1 == 8'b10000000)
        begin
          zero <= 1;
        end
      else if(num2 == 8'b00000000 | num2 == 8'b10000000)
        begin
          zero <= 2;
        end
      else
        begin
          zero <= 0;
        end
    end

  always@* //determine big number
    begin
      if(num2[6:4] > num1[6:4])
        begin
          big_num = num2;
          small_num = num1;
        end
      else if(num2[6:4] < num1[6:4])
        begin
          big_num = num1;
          small_num = num2;
        end
      else //if(num2[6:4] == num1[6:4])
        begin
          if(num2[3:0] > num1[3:0]) //if exponentials are the same, then compare fractions
            begin
              big_num = num2;
              small_num = num1;
            end
          else
            begin
              big_num = num1;
              small_num = num2;
            end
        end

    end

endmodule
