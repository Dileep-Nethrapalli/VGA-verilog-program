create_clock -name clock_100MHz -period 10.000 -waveform {0 5} [get_ports clock]

create_generated_clock -name Pixel_CLK -source [get_pins vga_controller/pixel_clock_reg/C] -divide_by 2 [get_pins vga_controller/pixel_clock_reg/Q] 

set_output_delay -clock [get_clocks Pixel_CLK] 1.0 [get_ports {HSYNC VSYNC RED[0] RED[1] RED[2] RED[3] GRN[0] GRN[1] GRN[2] GRN[3] BLU[0] BLU[1] BLU[2] BLU[3]}]

set_false_path -from [get_ports reset_n]

set_clock_groups -asynchronous -group [get_clocks clock_100MHz] -group [get_clocks Pixel_CLK] 
