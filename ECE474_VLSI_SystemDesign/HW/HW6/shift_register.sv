//Assignment: ECE 474 Homework 6
//Author Andrew Collins
//File: shift_Register.sv
//Description:  packet Byte assembling


module shift_register (
	input clk_50, // clock input
	input reset_n, //reset input ngative edge
	input serial_data, //signle bit input
	input data_ena, //read data enable input
	output reg [7:0] complete_byte // 8 bit output
);

reg [7:0] shift_reg;

always_ff @(posedge clk_50, negedge reset_n) begin
	if(!reset_n) 
		shift_reg <= '0;
	else begin
		if(data_ena) 
			shift_reg <= (serial_data) ? (shift_reg >> 1) + 8'b1000_0000 : (shift_reg >> 1) ;
		else shift_reg <=shift_reg;
	end
end

assign complete_byte = shift_reg; 


endmodule
