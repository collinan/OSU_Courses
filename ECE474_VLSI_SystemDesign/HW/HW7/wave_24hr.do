onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Clock Input}
add wave -noupdate /clock/clk_1ms
add wave -noupdate /clock/clk_1sec
add wave -noupdate /clock/mil_time
add wave -noupdate /clock/reset_n
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider MIN_SEG's
add wave -noupdate /clock/low_min_seg
add wave -noupdate /clock/high_min_seg
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider HR_SEG's
add wave -noupdate /clock/low_hr_seg
add wave -noupdate /clock/high_hr_seg
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider {Clock Output}
add wave -noupdate /clock/segment_data
add wave -noupdate /clock/digit_select
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37397500000 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 152
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
configure wave -timelineunits sec
update
WaveRestoreZoom {30378440484 ns} {131639908767 ns}

force -deposit /clk_1ms 1 0, 0 { 500000 ns } -repeat 1000000
force -deposit /clk_1sec 1 0, 0 { 500000000 ns } -repeat 1000000000
force mil_time 1
force reset_n 0
run 1 ms
force reset_n 1
run  120 min
