module clock(
  input             reset_n,             //reset pin
  input             clk_1sec,            //1 sec clock
  input             clk_1ms,             //1 mili sec clock
  input             mil_time,            //mil time pin
  output reg [6:0]  segment_data,        // output 7 segment data
  output reg [2:0]  digit_select         // digit select
  );

reg [9:0] msec_count;
reg [5:0] sec_count;
reg [6:0] low_min_seg;
reg [6:0] high_min_seg;
reg [6:0] low_hr_seg;
reg [6:0] high_hr_seg;

enum reg [2:0]{
MIN_LOW = 3'b000,
MINUTE_HIGH = 3'b001,
HOUR_LOW = 3'b010,
HOUR_HIGH = 3'b011,
SECOND_BLINK = 3'b100
}digit_select_ps,digit_select_ns;

/*
reg [6:0] ZERO_digit  = 7'b111_111_0;
reg [6:0] ONE_digit   = 7'b011_000_0;
reg [6:0] TWO_digit   = 7'b110_110_1;
reg [6:0] THREE_digit = 7'b111_100_1;
reg [6:0] FOUR_digit  = 7'b011_001_1;
reg [6:0] FIVE_digit  = 7'b101_101_1;
reg [6:0] SIX_digit   = 7'b101_111_1;
reg [6:0] SEVEN_digit = 7'b111_000_0;
reg [6:0] EIGHT_digit = 7'b111_111_1;
reg [6:0] NINE_digit  = 7'b111_101_1;
*/


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


minute minute_0(
  .reset_n(reset_n),             //reset pin
  .clk_1sec(clk_1sec),            //1 sec clock
  .mil_time(mil_time),            //mil time pin
  .sec_count(sec_count),
  .low_min_seg(low_min_seg),        // o
  .high_min_seg(high_min_seg)
  );

hour hour_0(
  .reset_n(reset_n),             //reset pin
  .clk_1sec(clk_1sec),            //1 sec clock
  .mil_time(mil_time),            //mil time pin
  .sec_count(sec_count),
  .low_min_seg(low_min_seg),
  .high_min_seg(high_min_seg),
  .low_hr_seg(low_hr_seg),        // o
  .high_hr_seg(high_hr_seg)
  );



//second counter
always_ff @(posedge clk_1sec, negedge reset_n)begin
  if(!reset_n ) msec_count <='0;
  else begin
    if (msec_count == 1000) msec_count <= '0;
    else msec_count <= msec_count +1;
  end
end

//ms counter
always_ff @(posedge clk_1ms, negedge reset_n)begin
  if(!reset_n ) sec_count <='0;
  else begin
    if (sec_count == 60) sec_count <= '0;
    else sec_count <= sec_count +1;
  end
end



always_ff @(posedge clk_1ms, negedge reset_n)begin
  if(!reset_n ) digit_select_ps <=MIN_LOW;
  else digit_select_ps <=digit_select_ns;
end

always_comb begin
  unique case(digit_select_ps)
    MIN_LOW      :begin
                  segment_data=low_min_seg;
                  digit_select = MIN_LOW;
                  digit_select_ns=MINUTE_HIGH;
                 end
    MINUTE_HIGH  :begin
                  segment_data=high_min_seg;
                  digit_select= MINUTE_HIGH;
                  digit_select_ns=HOUR_LOW;
                  end
    HOUR_LOW     :begin
                  segment_data=low_hr_seg;
                  digit_select=HOUR_LOW;
                  digit_select_ns=HOUR_HIGH;
                  end
    HOUR_HIGH    :begin
                  segment_data=high_hr_seg;
                  digit_select=HOUR_HIGH;
                  digit_select_ns=SECOND_BLINK;
                  end
    SECOND_BLINK :begin
                  segment_data=(msec_count == 1000)? 7'b111_111_1:7'b000_000_0;
                  digit_select=SECOND_BLINK;
                  digit_select_ns=MIN_LOW;
                  end
  endcase
end



endmodule
