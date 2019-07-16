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

read -p 'Please enter R to run regular 12 hr clock, or M to run 24 hr clock: ' hr

if [ $hr != "R" ] && [ $hr != "M" ]
then
	echo -e "Invali input"
	exit 1
fi

if [ $hr == 'R' ]
then
	vlog clock.sv
	echo -e "------\n"
	vlog minute.sv
	echo -e "------\n"
	vlog hour.sv
	echo -e "------\n"
	vsim -novopt clock -do wave_12hr.do
fi

if [ $hr == 'M' ]
then
	vlog clock.sv
	echo -e "------\n"
	vlog minute.sv
	echo -e "------\n"
	vlog hour.sv
	echo -e "------\n"
	vsim -novopt clock -do wave_24hr.do
fi
