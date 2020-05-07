###################################################################

# Created by write_sdc on Thu May  7 19:00:17 2020

###################################################################
set sdc_version 1.8

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_wire_load_mode segmented
set_wire_load_model -name smic18_wl10 -library slow
set_max_transition 3 [current_design]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports clk]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports reset]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[7]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[6]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[5]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[4]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[3]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[2]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[1]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports {data[0]}]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports write_enable]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports last_block]
set_driving_cell -lib_cell PO8W -pin PAD [get_ports first_block]
set_load -pin_load 4.37 [get_ports busy]
set_load -pin_load 4.37 [get_ports {digest[3]}]
set_load -pin_load 4.37 [get_ports {digest[2]}]
set_load -pin_load 4.37 [get_ports {digest[1]}]
set_load -pin_load 4.37 [get_ports {digest[0]}]
set_load -pin_load 4.37 [get_ports output_valid]
set_ideal_network [get_ports reset]
create_clock [get_ports clk]  -period 7.5  -waveform {0 3.75}
set_clock_latency 1  [get_clocks clk]
set_clock_latency -source 3  [get_clocks clk]
set_clock_uncertainty 0.3  [get_clocks clk]
set_clock_transition -rise 0.1 [get_clocks clk]
set_clock_transition -fall 0.1 [get_clocks clk]
set_input_delay -clock clk  -max 3.2  [get_ports reset]
set_input_delay -clock clk  -max 3.2  [get_ports {data[7]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[6]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[5]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[4]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[3]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[2]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[1]}]
set_input_delay -clock clk  -max 3.2  [get_ports {data[0]}]
set_input_delay -clock clk  -max 3.2  [get_ports write_enable]
set_input_delay -clock clk  -max 3.2  [get_ports last_block]
set_input_delay -clock clk  -max 3.2  [get_ports first_block]
set_output_delay -clock clk  -max 3.2  [get_ports busy]
set_output_delay -clock clk  -max 3.2  [get_ports {digest[3]}]
set_output_delay -clock clk  -max 3.2  [get_ports {digest[2]}]
set_output_delay -clock clk  -max 3.2  [get_ports {digest[1]}]
set_output_delay -clock clk  -max 3.2  [get_ports {digest[0]}]
set_output_delay -clock clk  -max 3.2  [get_ports output_valid]
