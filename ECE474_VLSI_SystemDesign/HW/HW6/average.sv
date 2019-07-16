//Assignment: ECE 474 Homework 6
//Author Andrew Collins
//File: average.sv
//Description:  Gets the average of the 4 temperatures,and send to ram.
//Also figures out memory address location, and creates ram write signal.

module average( 
       input clk_2,   //read clock
       input reset_n,  //reset async active low
	   input reg [7:0] data_out, //data out
       input read,
	   output reg ram_wr_n,
	   output reg [7:0] ram_data,
	   output reg [10:0] ram_addr       // ram address
	    ); 

reg [9:0] avg_reg;
reg [2:0] count;
reg [10:0] temp_ram_addr;
	
		
always_ff @(posedge clk_2, negedge reset_n) begin
	if(!reset_n) avg_reg<='0;
	else 
	if(count == 4) avg_reg <=0;
	else if(read)avg_reg <= avg_reg+data_out;
	else  avg_reg <= avg_reg;
end
		


always_ff @(posedge clk_2, negedge reset_n) begin
	if(!reset_n) count<='0;
	else begin 
		if(count == 4) count <=0;
		else if (read)count <= count+1;
		else count <= count;
	end
end		


always_ff @(posedge clk_2, negedge reset_n) begin
	if(!reset_n) temp_ram_addr<=11'h7FF;
	else begin 
		if(count == 4) temp_ram_addr<=temp_ram_addr-1;
		else if (temp_ram_addr==0)temp_ram_addr <= 11'h7FF;
		else temp_ram_addr <= temp_ram_addr;
	end
end		


assign ram_data = (count == 4) ? avg_reg[9:2] : 'X ;
assign ram_wr_n = (count == 4) ? '1 : 0 ;
assign ram_addr = (count == 4) ? temp_ram_addr : 'X ;

	
endmodule