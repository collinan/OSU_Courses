
module minute(
  input             reset_n,             //reset pin
  input             clk_1sec,            //1 sec clock
  input             mil_time,            //mil time pin
  input  reg [5:0]  sec_count,
  output reg [6:0]  low_min_seg,        // o
  output reg [6:0]  high_min_seg
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

enum reg [3:0]{
LOW_MIN_0 = 4'b0000,
LOW_MIN_1 = 4'b0001,
LOW_MIN_2 = 4'b0010,
LOW_MIN_3 = 4'b0011,
LOW_MIN_4 = 4'b0100,
LOW_MIN_5 = 4'b0101,
LOW_MIN_6 = 4'b0110,
LOW_MIN_7 = 4'b0111,
LOW_MIN_8 = 4'b1000,
LOW_MIN_9 = 4'b1001
}low_min_ps,low_min_ns;



enum reg [3:0]{
HIGH_MIN_0 = 4'b0000,
HIGH_MIN_1 = 4'b0001,
HIGH_MIN_2 = 4'b0010,
HIGH_MIN_3 = 4'b0011,
HIGH_MIN_4 = 4'b0100,
HIGH_MIN_5 = 4'b0101
}high_min_ps,high_min_ns;


//start: minute low--------------------------------------
always_ff @(posedge clk_1sec, negedge reset_n)begin
  if(!reset_n) low_min_ps<=LOW_MIN_0;
  else begin
      if(sec_count == 60) low_min_ps<=low_min_ns;
      else low_min_ps<=low_min_ps;
  end
end

always_comb begin
  unique case (low_min_ps)
  LOW_MIN_0:begin
              low_min_seg = ZERO_digit;
              low_min_ns = LOW_MIN_1;
            end
  LOW_MIN_1:begin
              low_min_seg = ONE_digit;
              low_min_ns = LOW_MIN_2;
            end
  LOW_MIN_2:begin
              low_min_seg = TWO_digit;
              low_min_ns = LOW_MIN_3;
            end
  LOW_MIN_3:begin
              low_min_seg = THREE_digit;
              low_min_ns = LOW_MIN_4;
            end
  LOW_MIN_4:begin
              low_min_seg = FOUR_digit;
              low_min_ns = LOW_MIN_5;
            end
  LOW_MIN_5:begin
              low_min_seg = FIVE_digit;
              low_min_ns = LOW_MIN_6;
            end
  LOW_MIN_6:begin
              low_min_seg = SIX_digit;
              low_min_ns = LOW_MIN_7;
            end
  LOW_MIN_7:begin
              low_min_seg = SEVEN_digit;
              low_min_ns = LOW_MIN_8;
            end
  LOW_MIN_8:begin
              low_min_seg = EIGHT_digit;
              low_min_ns = LOW_MIN_9;
            end
  LOW_MIN_9:begin
              low_min_seg = NINE_digit;
              low_min_ns = LOW_MIN_0;
            end
  endcase
end
//end: minute low--------------------------------------

//start: minute high--------------------------------------
always_ff @(posedge clk_1sec, negedge reset_n)begin
  if(!reset_n) high_min_ps<=HIGH_MIN_0;
  else begin
      if(sec_count == 60 && low_min_seg == NINE_digit) high_min_ps<=high_min_ns;
      else high_min_ps<=high_min_ps;
  end
end

always_comb begin
  unique case (high_min_ps)
  HIGH_MIN_0:begin
              high_min_seg = ZERO_digit;
              high_min_ns = HIGH_MIN_1;
            end
  HIGH_MIN_1:begin
              high_min_seg = ONE_digit;
              high_min_ns = HIGH_MIN_2;
            end
  HIGH_MIN_2:begin
              high_min_seg = TWO_digit;
              high_min_ns = HIGH_MIN_3;
            end
  HIGH_MIN_3:begin
              high_min_seg = THREE_digit;
              high_min_ns = HIGH_MIN_4;
            end
  HIGH_MIN_4:begin
              high_min_seg = FOUR_digit;
              high_min_ns = HIGH_MIN_5;
            end
  HIGH_MIN_5:begin
              high_min_seg = FIVE_digit;
              high_min_ns = HIGH_MIN_0;
            end
  endcase
end
//end: minute high--------------------------------------

endmodule
