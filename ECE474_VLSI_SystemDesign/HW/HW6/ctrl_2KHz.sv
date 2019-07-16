//Assignment: ECE 474 Homework 6
//Author Andrew Collins
//File: ctrl_2KHz.sv
//Description:  Creates the control signals for reading from fifo,
//averaging, and writing to ram.

module ctrl_2KHz(
	input 			clk_2,
	input 			reset_n,
	//input  			data_ena,             // serial data enable
	input 			empty,
	output reg		read,
	output reg 		avg_en
);	

enum reg[1:0] {
IDLE=2'b00,
READ=2'b01,
NO_READ =2'b10
}read_ps, read_ns;


always_ff @(posedge clk_2, negedge reset_n) begin
	if(!reset_n)begin
		read_ps <= IDLE;
	end
	else begin
	read_ps<= read_ns;
	end
end




always_comb begin
	unique case (read_ps)
		IDLE:
			if(!empty)begin
				read_ns = READ;
				read =1;
				avg_en =1;
			end
			else begin
				read_ns =IDLE;
				read =0;
			avg_en =0;
			end
		READ:begin
			//if(!empty) begin
				read_ns = NO_READ;
				read =0;
				avg_en =0;
				//end
			//else begin
			//	read_ns = NO_READ;
			//	avg_en =0;
			//	read=0;
			//end
		end
		NO_READ:begin
			if(!empty) begin
				read_ns = READ;
				avg_en =1;
				read=1;
			end
			else begin
				read_ns = IDLE;
				avg_en =0;
				read=0;
			end
		end
		
	endcase

end

endmodule