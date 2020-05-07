onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/reset
add wave -noupdate -radix hexadecimal /top_tb/data
add wave -noupdate /top_tb/write_enable
add wave -noupdate /top_tb/last_block
add wave -noupdate /top_tb/first_block
add wave -noupdate -radix hexadecimal /top_tb/digest
add wave -noupdate /top_tb/busy
add wave -noupdate /top_tb/output_valid
add wave -noupdate /top_tb/our_top/inner_busy
add wave -noupdate -radix hexadecimal /top_tb/our_top/Wt
add wave -noupdate -radix unsigned /top_tb/our_top/our_hash_core/round
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/H
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/G
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/F
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/E
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/D
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/C
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/B
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/A
add wave -noupdate -radix hexadecimal /top_tb/our_top/our_hash_core/Kt
add wave -noupdate -radix unsigned /top_tb/our_top/our_controller/counter2
add wave -noupdate -radix unsigned /top_tb/our_top/our_controller/counter1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1990 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {1320 ns} {2320 ns}
