//Assignment: ECE 474 Homework 5
//Author: Andrew Collins
//File: gcd.sv
//Description: Implementation on Elucid's greast common divisor
//


module gcd( input [31:0] a_in,          //operand a
            input [31:0] b_in,          //operand b
            input start,                //validates the input data
            input reset_n,              //reset
            input clk,                  //clock
            output reg [31:0] result,  //output of GCD engine
            output reg done);          //validates output value

//32-bit registers
reg [31:0] a_reg;
reg [31:0] b_reg;

//temp register to hold a or b
//reg [31:0] swap_reg;


enum reg [1:0]{ 
	IDLE = 2'b00,
	RUN = 2'b01,
	DONE = 2'b10
}gcd_ps,gcd_ns;


enum reg [1:0]{ 
		LOAD_A = 2'b00,
		SWAP_A = 2'b01,
		SUB_A  = 2'b10,
		HOLD_A = 2'b11
	}a_state;


enum reg [1:0]{ 
		LOAD_B = 2'b00,
		SWAP_B = 2'b01,
		SUB_B  = 2'b10,
		HOLD_B = 2'b11
	}b_state;

//gcd states
always_ff @(posedge clk, negedge reset_n) begin

	if(!reset_n) gcd_ps <= IDLE;
	else gcd_ps <=gcd_ns;
end


//a_reg processing
always_ff @(posedge clk, negedge reset_n) begin
	if(!reset_n) a_reg <= '0;
	else
	   unique case(a_state)
   			LOAD_A: a_reg <= a_in;
			SWAP_A: a_reg <= b_reg;
			SUB_A : a_reg <= a_reg - b_reg;
			HOLD_A: a_reg <= a_reg;		
		endcase
end

//b_reg processing
always_ff @(posedge clk, negedge reset_n) begin
	if(!reset_n) b_reg <= '0;
	else 
	   unique case(b_state)
   			LOAD_B: b_reg <= b_in;
			SWAP_B: b_reg <= a_reg;
			SUB_B : b_reg <= b_reg;
			HOLD_B: b_reg <= b_reg;
		endcase		
end


assign a_lt_b = ( a_reg < b_reg)  ? 1 : 0;//a<b then swap else subtract (1 is true)  
assign b_neq_zero =  (b_reg != 0) ? 1 : 0;//(1 is true)


//set output result
//assign result = a_reg;



always_comb begin
	unique case(gcd_ps)
		IDLE: 
		     if(start)begin 
				gcd_ns=RUN;
				a_state=LOAD_A;
				b_state=LOAD_B;
				done = '0;
			  end
			  else begin 
				gcd_ns=IDLE;
//				a_state=HOLD_A;
//				b_state=HOLD_B;
				done = 'X;
			  end	  
		RUN:
			if(b_neq_zero)begin//if b !=0
				unique case ( a_lt_b)
					0: begin//sub
						 a_state=SUB_A;
						 b_state=SUB_B;
				   	   end
				    1: begin//swap
						 a_state=SWAP_A;
					 	 b_state=SWAP_B;
				       end
				endcase
			    gcd_ns=RUN;
				done = '0;
		   end
		   else begin
				gcd_ns=DONE;
			result = a_reg;
				a_state=HOLD_A;
				b_state=HOLD_B;
		   end
		DONE: begin
				gcd_ns=IDLE;	
				done = '1;
			 end
	endcase
end




endmodule
