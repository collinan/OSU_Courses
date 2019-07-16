//Assignment: ECE 474 Homework 6
//Author Andrew Collins
//File: a5_c3.sv
//Description:  Checks to see if packet byte is a header
module a5_c3 (
	input clk_50, // clock input
	input reset_n, //reset input ngative edge
	input data_ena, //read data enable input
	input reg [7:0] complete_byte, // 8 bit output
	output wire a5_or_c3
);

assign a5_or_c3 = (( complete_byte == 8'hA5) || (complete_byte == 8'hC3)) ? 1 : 0;


endmodule