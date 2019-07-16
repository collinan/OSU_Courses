//Author: Andrew Collins
//File: mult_ctl.sv


module mult_ctl(
	input reset,
	input clk,
	input start,
	input multiplier_bit0,
	output logic prod_reg_ld_high,
	output logic prod_reg_shift_rt,
	output logic done);
	
	
enum logic [1:0]{
	IDLE = 2'b00,
	OP = 2'b01,//check operation of next state
	ADD = 2'b10,
	SHIFT = 2'b11} ps, ns;	
	
logic [4:0]cycle_cnt;	

always_ff @(posedge clk, posedge reset) begin

	if(reset)
		begin
			ps <= IDLE;
		
		end
	else if(start)
		begin
			ps <= OP;
			
		end
	else
		begin
			ps<=ns;

		end
end


always_ff @(posedge clk, posedge reset) begin
	if(reset)
		begin
			cycle_cnt<='x;
		end
	else if(start)
		begin
			cycle_cnt<='0;
		end
	else 	
		begin
			if(ps==SHIFT)
				cycle_cnt<=cycle_cnt+1;
			else
				cycle_cnt<= cycle_cnt;
		end
end



always_comb begin
	unique case( ps )
		IDLE: begin //do nothing all signals 0
						prod_reg_ld_high='0;//de-activate high
						prod_reg_shift_rt='0;//de-activate shift
						ns=IDLE;
						
			  end
		OP: begin //do nothing all signals 0
				prod_reg_ld_high='0;//activate ld high
				prod_reg_shift_rt='0;//de-activate shift 
			
			if(multiplier_bit0)ns=ADD;
			else ns=SHIFT;
			  end
		ADD: begin
			prod_reg_ld_high='1;//activate ld high
			prod_reg_shift_rt='0;//de-activate shift 
			ns=SHIFT;
			end
		SHIFT: begin
			
			if(cycle_cnt == 5'b11111)begin
				ns=IDLE;
				done='1;
			prod_reg_shift_rt='1;//activate shift
			prod_reg_ld_high='0;//de-activate ld high
				end
			else
			begin
			ns=OP;
			prod_reg_shift_rt='1;//activate shift
			prod_reg_ld_high='0;//de-activate ld high
			done='0;
			end
			
				
		   end
	endcase	
end
	
endmodule