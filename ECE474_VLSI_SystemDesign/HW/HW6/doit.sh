#!/bin/bash -e

#if work dir does not exist create it
if [ ! -d work ]
then
	echo -e "\n **********Creating work Directory***********"
	vlib work
	#sysnthesis the cell library into /work ******************
	vlog /nfs/guille/a1/cadlibs/synop_lib/SAED_EDK90nm/Digital_Standard_Cell_Library/verilog/*.v
	echo
fi


if [ $# -ne 1 ] 
then
echo -e "Please enter:-"
echo -e "./doit.sh c -> to compile .sv file"
echo -e "./doit.sh r -> to compile .sv file and run vsim testbench\n"
exit 1
fi

echo $1

if [ $1 != 'c' ] && [ $1 != 'r' ] 
then
echo -e "Please enter:"
echo -e "./doit.sh c -> to compile .sv file"
echo -e "./doit.sh r -> to compile .sv file and run vsim testbench\n"
exit 1
fi


if [ $1 == 'c' ]
then
	vlog tas.sv
	echo -e "------\n"
	vlog shift_register.sv
	echo -e "------\n"
	vlog fifo.sv
	echo -e "------\n"
	vlog ctrl_50MHz.sv
	echo -e "------\n"
	vlog ctrl_2KHz.sv
	echo -e "------\n"
	vlog a5_c3.sv	
	echo -e "------\n"
	vlog average.sv
	echo -e "------\n"
	vlog tb.sv
	echo -e "------\n"

fi


if [ $1 == 'r' ]
then
	vlog tas.sv
	echo -e "------\n"
	vlog fifo.sv
	echo -e "------\n"
	vlog shift_register.sv
	echo -e "------\n"
	vlog ctrl_50MHz.sv
	echo -e "------\n"
	vlog ctrl_2KHz.sv
	echo -e "------\n"
	vlog a5_c3.sv	
	echo -e "------\n"
	vlog average.sv
	echo -e "------\n"
	vlog tb.sv
	echo -e "------\n"

	vsim -novopt tb -do wave.do
fi




