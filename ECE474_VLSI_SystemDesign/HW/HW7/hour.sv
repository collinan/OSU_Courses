
module hour(
  input             reset_n,             //reset pin
  input             clk_1sec,            //1 sec clock
  input             mil_time,            //mil time pin
  input  reg [5:0]  sec_count,
  input  reg [6:0]  low_min_seg,
  input  reg [6:0]  high_min_seg,
  output reg [6:0]  low_hr_seg,        //
  output reg [6:0]  high_hr_seg
  );

parameter ZERO_digit  = 7'b111_111_0;//hex = 7E
parameter ONE_digit   = 7'b011_000_0;//hex = 30
parameter TWO_digit   = 7'b110_110_1;//hex = 6D
parameter THREE_digit = 7'b111_100_1;//hex = 79
parameter FOUR_digit  = 7'b011_001_1;//hex = 33
parameter FIVE_digit  = 7'b101_101_1;//hex = 5B
parameter SIX_digit   = 7'b101_111_1;//hex = 5F
parameter SEVEN_digit = 7'b111_000_0;//hex = 70
parameter EIGHT_digit = 7'b111_111_1;//hex = 7F
parameter NINE_digit  = 7'b111_101_1;//hex = 7B

enum reg [4:0]{
HR_0  = 0,
HR_1  = 1,
HR_2  = 2,
HR_3  = 3,
HR_4  = 4,
HR_5  = 5,
HR_6  = 6,
HR_7  = 7,
HR_8  = 8,
HR_9  = 9,
HR_10 = 10,
HR_11 = 11,
HR_12 = 12,
HR_13 = 13,
HR_14 = 14,
HR_15 = 15,
HR_16 = 16,
HR_17 = 17,
HR_18 = 18,
HR_19 = 19,
HR_20 = 20,
HR_21 = 21,
HR_22 = 22,
HR_23 = 23
}hr_ps,hr_ns;




always_ff @(posedge clk_1sec, negedge reset_n)begin
  if(!reset_n)
    if(mil_time)hr_ps <= HR_0;
    else hr_ps <= HR_12;
  else begin
      if( (sec_count == 60) && (high_min_seg == FIVE_digit) && (low_min_seg == NINE_digit) )
       hr_ps<=hr_ns;
      else hr_ps<=hr_ps;
  end
end



always_comb begin
  unique case (hr_ps)
  HR_0 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = ZERO_digit;
          hr_ns = HR_1;
        end
  HR_1 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = ONE_digit;
          hr_ns = HR_2;
        end
  HR_2 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = TWO_digit;
          hr_ns = HR_3;
        end
  HR_3 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = THREE_digit;
          hr_ns = HR_4;
        end
  HR_4 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = FOUR_digit;
          hr_ns = HR_5;
        end
  HR_5 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = FIVE_digit;
          hr_ns = HR_6;
        end
  HR_6 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = SIX_digit;
          hr_ns = HR_7;
        end
  HR_7 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = SEVEN_digit;
          hr_ns = HR_8;
        end
  HR_8 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = EIGHT_digit;
          hr_ns = HR_9;
        end
  HR_9 :begin
          high_hr_seg = ZERO_digit;
          low_hr_seg = NINE_digit;
          hr_ns = HR_10;
        end
  HR_10:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = ZERO_digit;
          hr_ns = HR_11;
        end
  HR_11:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = ONE_digit;
          hr_ns = HR_12;
        end
  HR_12:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = TWO_digit;
          if(mil_time) hr_ns = HR_13;
          else hr_ns = HR_1;
        end
  HR_13:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = THREE_digit;
          hr_ns = HR_14;
        end
  HR_14:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = FOUR_digit;
          hr_ns = HR_15;
        end
  HR_15:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = FIVE_digit;
          hr_ns = HR_16;
        end
  HR_16:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = SIX_digit;
          hr_ns = HR_17;
        end
  HR_17:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = SEVEN_digit;
          hr_ns = HR_18;
        end
  HR_18:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = EIGHT_digit;
          hr_ns = HR_19;
        end
  HR_19:begin
          high_hr_seg = ONE_digit;
          low_hr_seg = NINE_digit;
          hr_ns = HR_20;
        end
  HR_20:begin
          high_hr_seg = TWO_digit;
          low_hr_seg = ZERO_digit;
          hr_ns = HR_21;
        end
  HR_21:begin
          high_hr_seg = TWO_digit;
          low_hr_seg = ONE_digit;
          hr_ns = HR_22;
        end
  HR_22:begin
          high_hr_seg = TWO_digit;
          low_hr_seg = TWO_digit;
          hr_ns = HR_23;
        end
  HR_23:begin
          high_hr_seg = TWO_digit;
          low_hr_seg = THREE_digit;
          hr_ns = HR_0;
        end
  endcase
end
//end: hour --------------------------------------

endmodule
