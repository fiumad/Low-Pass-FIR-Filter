create_clock -name clk -period 0.5 [get_ports clk]
set_input_delay -clock clk 100.000 [get_ports x_in]
set_output_delay -clock clk 100.000 [get_ports y_out]
