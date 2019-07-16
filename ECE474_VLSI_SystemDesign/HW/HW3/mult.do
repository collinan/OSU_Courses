force a_in 10#14
force b_in 10#9
add wave -position insertpoint \
sim:/mult/a_in \
sim:/mult/b_in \
sim:/mult/clk \
sim:/mult/reset \
sim:/mult/start \
sim:/mult/done \
sim:/mult/prod_reg_high \
sim:/mult/prod_reg_low \
sim:/mult/product \
sim:/mult/multiplier_bit0 \
sim:/mult/prod_reg_ld_high \
sim:/mult/prod_reg_shift_rt
force -freeze sim:/mult/clk 1 0, 0 {50 ns} -r 100
force reset 1
force start 0
run 150
force reset 0
run 100
force start 1
run 100
force start 0
run 800 
run 6000


