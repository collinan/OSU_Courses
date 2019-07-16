#!/bin/bash

#if work dir does not exist create it
if [ ! -d work ]
then
echo -e "\n **********Creating work Directory***********"
	vlib work
	echo
fi

if [ -e mult.sv ] && [ -e mult_ctl.sv ]
then
echo -e "\n **********Compiling mult.sv***********"
vlog mult_ctl.sv
vlog mult.sv
echo
fi


if [ -e mult.do ]
then
echo -e "\n **********Simulating***********"
	#vsim -novopt mult -do  mult.do -quiet -c
	vsim mult -do  mult.do -quiet -c -t 1ps +nowarnTFMPC +nowarnTSCALE quit
	mv mult.list mult.golden.list
echo
fi

#synthesize design
if [ -e syn_mult ]
then
echo -e "\n **********synthesize the design***********"
dc_shell-xg-t -f syn_mult quit
echo
fi

#sysnthesis the cell library into /work ******************
vlog /nfs/guille/a1/cadlibs/synop_lib/SAED_EDK90nm/Digital_Standard_Cell_Library/verilog/*.v



#vompiling gate file
if [ -e syn_mult ]
then
echo -e "\n **********Compiling gate file***********"
vlog mult.gate.v
echo
fi

if [ -e mult.do ]
then
echo -e "\n **********Simulating***********"
	#vsim -novopt mult -do  mult.do -quiet -c
	vsim mult -do  mult.do -quiet -c -t 1ps +nowarnTFMPC +nowarnTSCALE quit
echo
fi


#check diff: compare simulation results (.sv vs .v)********************
diff mult.list mult.golden.list >| diff_report

if [ ! -s "diff_file" ]; then
	echo "****Gate list file Matches rtl list file****"
else
	echo "****Gate list file Does not Match rtl list file****"
fi

