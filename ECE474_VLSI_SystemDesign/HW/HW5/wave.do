onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/input_file
add wave -noupdate /tb/output_file
add wave -noupdate /tb/in
add wave -noupdate /tb/out
add wave -noupdate /tb/i
add wave -noupdate /tb/clk
add wave -noupdate /tb/reset_n
add wave -noupdate /tb/start
add wave -noupdate /tb/done
add wave -noupdate -radix unsigned /tb/a_in
add wave -noupdate -radix unsigned /tb/b_in
add wave -noupdate /tb/result
add wave -noupdate /tb/gcd_0/a_in
add wave -noupdate /tb/gcd_0/b_in
add wave -noupdate /tb/gcd_0/start
add wave -noupdate /tb/gcd_0/reset_n
add wave -noupdate /tb/gcd_0/clk
add wave -noupdate -radix unsigned /tb/gcd_0/result
add wave -noupdate /tb/gcd_0/done
add wave -noupdate -radix unsigned /tb/gcd_0/a_reg
add wave -noupdate -radix unsigned /tb/gcd_0/b_reg
add wave -noupdate /tb/gcd_0/gcd_ps
add wave -noupdate /tb/gcd_0/gcd_ns
add wave -noupdate /tb/gcd_0/a_state
add wave -noupdate /tb/gcd_0/b_state
add wave -noupdate /tb/gcd_0/a_lt_b
add wave -noupdate /tb/gcd_0/b_neq_zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {1 us}
