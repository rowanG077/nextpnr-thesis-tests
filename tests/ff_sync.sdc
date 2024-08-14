create_clock -period 20.50 [ get_ports "clk_src" ]
create_clock -period 25.95 [ get_ports "clk_dst" ]
set_false_path -from [ get_nets "src_ff" ] -to [ get_nets "sync_ff1" ]
set_false_path -from [ get_nets "sync_ff1" ] -to [ get_nets "sync_ff2" ]
