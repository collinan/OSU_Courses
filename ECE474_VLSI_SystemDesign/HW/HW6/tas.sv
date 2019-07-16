//Assignment: ECE 474 Homework 6
//Author Andrew Collins
//File: tas.sv
//Description:  Temperature System. written in system verilog.
//System handles logging of data from a satellite.

module tas (
       input  clk_50,               // 50Mhz input clock
       input  clk_2,                // 2Mhz input clock
       input  reset_n,              // reset async active low
       input  serial_data,          // serial input data
	   input  data_ena,             // serial data enable
       output ram_wr_n,             // write strobe to ram
       output [7:0] ram_data,       // ram data
       output [10:0] ram_addr       // ram address
       );

	reg [7:0] complete_byte;
	reg [7:0] data_out;
	wire a5_or_c3;
	wire write;
	wire read;

//read 8 bits
shift_register shift_register_0(
	.clk_50 (clk_50), // clock input
	.reset_n (reset_n), //reset input negative edge
	.serial_data (serial_data), //single bit input
	.data_ena (data_ena), //read data enable input
	.complete_byte ( complete_byte)// 8 bit output
);

//check a5 or c3
a5_c3 a5_c3_0(
	.clk_50 (clk_50), // clock input
	.reset_n (reset_n), //reset input negative edge (might use
	.data_ena (data_ena), //read data enable input (might use)
	.complete_byte ( complete_byte),// 8 bit output
	.a5_or_c3(a5_or_c3)
);

//50 MHZ controller
ctrl_50MHz ctrl_50MHz_0(
	.clk_50 (clk_50), // clock input
	.reset_n (reset_n), //reset input negative edge
	.data_ena (data_ena), //read data enable input
	.a5_or_c3(a5_or_c3),
	.complete_byte ( complete_byte),// 8 bit output
	.write (write)
);	

//2KHZ controller 
ctrl_2KHz ctrl_2KHz_0(
	.clk_2 (clk_2), // clock input
	.reset_n (reset_n), //reset input negative edge
	//.data_ena (data_ena), //read data enable input
	.empty(empty),//input
	.read (read),
	.avg_en(avg_en)
);	

//fifo
fifo fifo_0( 
       .wr_clk (clk_50),   //write clock
       .rd_clk (clk_2),   //read clock
       .reset_n (reset_n),  //reset async active low
        .wr (write),       //write enable 
       .rd (read),       //read enable    
       .data_in (complete_byte),  //data in
       .data_out(data_out), //data out
       .empty(empty),    //empty flag
       .full(full)			//full flag
	   );  

//average
average average_0( 
       .clk_2 (clk_2),   //read clock
       .reset_n (reset_n),  //reset async active low
	   .data_out(data_out), //data out
       .read (read),
	   .ram_wr_n(ram_wr_n),
	   .ram_data(ram_data),
	   .ram_addr(ram_addr)      // ram address
	    );  
   



endmodule
