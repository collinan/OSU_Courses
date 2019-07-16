onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb/send_byte/in_byte
add wave -noupdate /tb/tas_0/clk_50
add wave -noupdate /tb/tas_0/clk_2
add wave -noupdate /tb/tas_0/reset_n
add wave -noupdate /tb/tas_0/serial_data
add wave -noupdate /tb/tas_0/data_ena
add wave -noupdate /tb/tas_0/complete_byte
add wave -noupdate /tb/tas_0/a5_c3_0/a5_or_c3
add wave -noupdate -divider {TAS OUT}
add wave -noupdate /tb/tas_0/ram_wr_n
add wave -noupdate -radix unsigned /tb/tas_0/ram_data
add wave -noupdate /tb/tas_0/ram_addr
add wave -noupdate -divider {CTRL 50MHZ}
add wave -noupdate /tb/tas_0/ctrl_50MHz_0/write
add wave -noupdate -divider FIFO
add wave -noupdate /tb/tas_0/fifo_0/data_in
add wave -noupdate /tb/tas_0/fifo_0/wr
add wave -noupdate -radix unsigned /tb/tas_0/fifo_0/mem0
add wave -noupdate -radix unsigned /tb/tas_0/fifo_0/mem1
add wave -noupdate -radix unsigned /tb/tas_0/fifo_0/mem2
add wave -noupdate -radix unsigned /tb/tas_0/fifo_0/mem3
add wave -noupdate /tb/tas_0/fifo_0/full
add wave -noupdate -radix unsigned /tb/tas_0/fifo_0/wr_ptr
add wave -noupdate /tb/tas_0/fifo_0/rd_ptr
add wave -noupdate -radix unsigned /tb/tas_0/data_out
add wave -noupdate /tb/tas_0/fifo_0/rd
add wave -noupdate /tb/tas_0/fifo_0/empty
add wave -noupdate -divider CTRL_2KHz
add wave -noupdate /tb/tas_0/ctrl_2KHz_0/read
add wave -noupdate /tb/tas_0/ctrl_2KHz_0/avg_en
add wave -noupdate -divider Average
add wave -noupdate -radix unsigned /tb/tas_0/average_0/avg_reg
add wave -noupdate /tb/tas_0/average_0/ram_wr_n
add wave -noupdate -radix decimal /tb/tas_0/average_0/ram_data
add wave -noupdate /tb/tas_0/average_0/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {60 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 261
configure wave -valuecolwidth 144
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
WaveRestoreZoom {0 ns} {2609 ns}
