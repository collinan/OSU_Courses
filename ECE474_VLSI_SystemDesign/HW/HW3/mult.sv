//Author: Andrew Collins
//File: mult.sv
//
module mult(
	input reset,
	input clk,
	input [31:0] a_in,
	input [31:0] b_in,
	input start,
	output logic [63:0] product,
	output logic done);
	
	logic [31:0] prod_reg_high;//output, upper half of product reg
	logic [31:0] prod_reg_low;//output, lower half of product reg
	logic multiplier_bit0;
	logic prod_reg_ld_high;
   	logic prod_reg_shift_rt;
	

	
always_ff @(posedge clk, posedge reset) begin
	if(reset)
		begin
			prod_reg_high <= '0;
			prod_reg_low <= '0;
			
			done <='0;
		end
	else if(start)
		begin
			prod_reg_high <= '0;
			prod_reg_low <= b_in;
			
		end
	else
		begin
		prod_reg_high <= prod_reg_high;
		prod_reg_low <= prod_reg_low;
		
		end
end


always_ff @(posedge clk, posedge reset)
 begin
	unique if(prod_reg_ld_high)
			begin
			prod_reg_high <=  a_in + prod_reg_high;
			
			end
	else if (prod_reg_shift_rt)
			begin
			{ prod_reg_high,prod_reg_low} <= {prod_reg_high,prod_reg_low} >> 1;
			end 
	//else 	{ prod_reg_high,prod_reg_low} <= {prod_reg_high,prod_reg_low};
end

	assign product = { prod_reg_high, prod_reg_low};
	assign multiplier_bit0=prod_reg_low[0];



mult_ctl mult_ctl_0(
.reset              (reset ),//input
.clk                (clk ),//input
.start              (start),//input
.multiplier_bit0  (multiplier_bit0),//input
.prod_reg_ld_high   (prod_reg_ld_high),//output
.prod_reg_shift_rt  (prod_reg_shift_rt),//output
.done               (done));//output
	

endmodule