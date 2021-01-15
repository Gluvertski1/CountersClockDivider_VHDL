onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bin_counter_tb/clk
add wave -noupdate /bin_counter_tb/reset
add wave -noupdate /bin_counter_tb/syn_clr
add wave -noupdate /bin_counter_tb/load
add wave -noupdate /bin_counter_tb/en
add wave -noupdate /bin_counter_tb/up
add wave -noupdate /bin_counter_tb/d
add wave -noupdate /bin_counter_tb/max_tick
add wave -noupdate /bin_counter_tb/min_tick
add wave -noupdate /bin_counter_tb/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {228 ps} 0}
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
configure wave -gridperiod 100000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2163 ns}