//ECE 474 Homework 2
//

module alu(
	input 		[7:0] in_a, //input a
	input 		[7:0] in_b, //input b
	input 		[3:0] opcode, //opcode input
	output reg 	[7:0] alu_out, //aluoutput
	output reg 		  alu_zero, //logic '1' when alu_output [7:0] is all zeros
	output reg 		  alu_carry //indicates a carry out from ALU
);

	parameter c_add = 4'h1;
	parameter c_sub = 4'h2;
	parameter c_inc = 4'h3;
	parameter c_dec = 4'h4;
	parameter c_or = 4'h5;
	parameter c_and = 4'h6;
	parameter c_xor = 4'h7;
	parameter c_shr = 4'h8;
	parameter c_shl = 4'h9;
	parameter c_onescomp = 4'ha;
	parameter c_twoscomp = 4'hb;

	logic [8:0] result;

	always_comb begin
		result ='0;
		case(opcode)
			c_add : result = in_a + in_b;
			c_sub : result = in_a - in_b;
			c_inc : result = in_a + 1;
			c_dec : result = in_a - 1;
			c_or  : result = in_a | in_b; //in_a OR in_b
			c_and : result = in_a & in_b; //in_a AND in_b
			c_xor : result = in_a ^ in_b; //in_a XOR in_b
			c_shr : result = in_a >> 1; //in_a is shifted one place right, zero shifted in
			c_shl : begin 
					result = in_a; //in_a is shifted one place left, zero shifted in
					result = result << 1;
					end
			c_onescomp : result =~in_a; //in_a gets "ones complemented"
			c_twoscomp : result =~in_a + 1; // gets "twos complemented"
			default : result = 'X;
		endcase
	end

	assign alu_carry = result[8];
	assign alu_out = result[7:0];
	assign alu_zero= ~|result[7:0];//NOR all bits in result[7:0] 0 NOR 0 = 1	

endmodule	
