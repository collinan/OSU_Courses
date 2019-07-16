//Assignment: ECE 474 Homework 6
//Author Andrew Collins
//File: ctrl_50MHz.sv
//Description:  File creates the control signals for data collection. 

module ctrl_50MHz(
	input 			clk_50,
	input 			reset_n,
	input  			data_ena,             // serial data enable
	input wire 		a5_or_c3,
	input reg [7:0] complete_byte, // 8 bit output
	output reg		write
);	

//byte status
enum reg [1:0]{
IDLE =2'b00,
ASSEMBLING =2'b01,
ASSEMBLED =2'b10
}byte_ps,byte_ns;

//which Packet Byte type 
enum reg [2:0]{
	HEADER   = 3'b000,
	DATA_1 = 3'b001,
	DATA_2 = 3'b010,
	DATA_3 = 3'b011,
	DATA_4 = 3'b100
}type_ps,type_ns;



//byte status
always_ff @(posedge clk_50	, negedge reset_n) begin
if(!reset_n) byte_ps <= ASSEMBLING;
	else byte_ps <= byte_ns;
end



//packet byte status
always_ff @(posedge clk_50, negedge reset_n)begin
	if(!reset_n) type_ps <= HEADER;
	else type_ps<=type_ns;
end

always_comb begin
	unique case (type_ps)
		HEADER: begin 
					//if((!data_ena) && (a5_or_c3))begin
					if((!data_ena) && (a5_or_c3) && (byte_ns==ASSEMBLED))begin
						type_ns = DATA_1;
						write = 0;
					end
					else begin
						type_ns = HEADER;
						write = 0;//write_ns = NO_WRITE;
						
					end
				end
		DATA_1: begin
					if((!data_ena) && (~complete_byte[7]) && (byte_ns==ASSEMBLED)) begin
						type_ns = DATA_2; //if assembled byte and temp less than 127
						write = 1;//write_ns = WRITE;
					end
					else begin
						type_ns = DATA_1;
						write = 0;//write_ns = NO_WRITE;
					end
				end
		DATA_2: begin
					if((!data_ena) && (~complete_byte[7]) && (byte_ns==ASSEMBLED)) begin
						type_ns = DATA_3; //if assembled byte and temp less than 127
						write = 1;//write_ns = WRITE;
					end
					else begin 
						type_ns = DATA_2;
						write = 0;//write_ns = NO_WRITE;
					end
				end
		DATA_3: begin
					if((!data_ena) && (~complete_byte[7]) && (byte_ns==ASSEMBLED))begin
						type_ns = DATA_4; //if assembled byte and temp less than 127
						write = 1;//write_ns = WRITE;
					end
					else begin
						type_ns = DATA_3;
						write = 0;//write_ns = NO_WRITE;
					end
				end
		DATA_4: begin
					if((!data_ena) && (~complete_byte[7]) && (byte_ns==ASSEMBLED)) begin
						type_ns = HEADER; //if assembled byte and temp less than 127
						write = 1;//write_ns = WRITE;
					end
					else begin
						type_ns = DATA_4;
						write = 0;//write_ns= NO_WRITE;
					end
				end	
	endcase
end





always_comb begin
	unique case(byte_ps)
		IDLE:begin
					if(data_ena)begin 
						byte_ns = ASSEMBLING;
					end
					else begin
						byte_ns = IDLE;
					end	
				end
		ASSEMBLING:begin
					if(data_ena)begin 
						byte_ns = ASSEMBLING;
						end
					else begin
						byte_ns = ASSEMBLED;
					end
				end
		ASSEMBLED: begin
					 byte_ns = IDLE;
					 end
	endcase
end



endmodule
