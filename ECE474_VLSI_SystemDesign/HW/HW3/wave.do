onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /mult/a_in
add wave -noupdate -radix decimal /mult/b_in
add wave -noupdate /mult/clk
add wave -noupdate /mult/reset
add wave -noupdate /mult/start
add wave -noupdate /mult/done
add wave -noupdate /mult/prod_reg_high
add wave -noupdate /mult/prod_reg_low
add wave -noupdate /mult/product
add wave -noupdate /mult/multiplier_bit0
add wave -noupdate /mult/prod_reg_ld_high
add wave -noupdate /mult/prod_reg_shift_rt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6290 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {6200 ns} {7200 ns}
