## Generated SDC file "DE10_Standard_D8M_RTL.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Wed Oct  7 22:46:58 2020"

##
## DEVICE  "5CSXFC6D6F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK2_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK2_50}]
create_clock -name {CLOCK3_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK3_50}]
create_clock -name {CLOCK4_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK4_50}]
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]
create_clock -name {MIPI_PIXEL_CLK} -period 40.000 -waveform { 0.000 20.000 } [get_ports {MIPI_PIXEL_CLK}]
create_clock -name {MIPI_PIXEL_CLK_ext} -period 40.000 -waveform { 0.000 20.000 } 


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clk_dram_ext} -source [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -master_clock {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} [get_ports {DRAM_CLK}] 
create_generated_clock -name {clk_vga_ext} -source [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -master_clock {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -invert [get_ports {VGA_CLK}] 
create_generated_clock -name {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 12 -divide_by 2 -master_clock {CLOCK2_50} [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 3 -master_clock {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 3 -phase 270/1 -master_clock {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 12 -divide_by 2 -master_clock {CLOCK_50} [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 15 -master_clock {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 12 -master_clock {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_vga_ext}] -setup 0.220  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_vga_ext}] -hold 0.210  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_vga_ext}] -setup 0.220  
set_clock_uncertainty -rise_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_vga_ext}] -hold 0.210  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_vga_ext}] -setup 0.220  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_vga_ext}] -hold 0.210  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_vga_ext}] -setup 0.220  
set_clock_uncertainty -fall_from [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_vga_ext}] -hold 0.210  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_dram_ext}] -setup 0.230  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_dram_ext}] -hold 0.220  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_dram_ext}] -setup 0.230  
set_clock_uncertainty -rise_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_dram_ext}] -hold 0.220  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.220  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {MIPI_PIXEL_CLK}]  0.200  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {MIPI_PIXEL_CLK}]  0.200  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_dram_ext}] -setup 0.230  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {clk_dram_ext}] -hold 0.220  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_dram_ext}] -setup 0.230  
set_clock_uncertainty -fall_from [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {clk_dram_ext}] -hold 0.220  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.200  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.200  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.200  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK_ext}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK_ext}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK_ext}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {MIPI_PIXEL_CLK_ext}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK_ext}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK_ext}] -rise_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.090  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK_ext}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {MIPI_PIXEL_CLK_ext}] -fall_to [get_clocks {MIPI_PIXEL_CLK}] -hold 0.090  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK4_50}]  0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK4_50}]  0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK3_50}]  0.240  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK3_50}]  0.240  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK4_50}]  0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK4_50}]  0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {CLOCK3_50}]  0.240  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {CLOCK3_50}]  0.240  
set_clock_uncertainty -rise_from [get_clocks {clk_dram_ext}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.230  
set_clock_uncertainty -rise_from [get_clocks {clk_dram_ext}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.220  
set_clock_uncertainty -rise_from [get_clocks {clk_dram_ext}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.230  
set_clock_uncertainty -rise_from [get_clocks {clk_dram_ext}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.220  
set_clock_uncertainty -fall_from [get_clocks {clk_dram_ext}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.230  
set_clock_uncertainty -fall_from [get_clocks {clk_dram_ext}] -rise_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.220  
set_clock_uncertainty -fall_from [get_clocks {clk_dram_ext}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.230  
set_clock_uncertainty -fall_from [get_clocks {clk_dram_ext}] -fall_to [get_clocks {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.220  
set_clock_uncertainty -rise_from [get_clocks {CLOCK4_50}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {CLOCK4_50}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -rise_from [get_clocks {CLOCK4_50}] -rise_to [get_clocks {CLOCK4_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK4_50}] -rise_to [get_clocks {CLOCK4_50}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK4_50}] -fall_to [get_clocks {CLOCK4_50}] -setup 0.310  
set_clock_uncertainty -rise_from [get_clocks {CLOCK4_50}] -fall_to [get_clocks {CLOCK4_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK4_50}] -rise_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {CLOCK4_50}] -fall_to [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}]  0.260  
set_clock_uncertainty -fall_from [get_clocks {CLOCK4_50}] -rise_to [get_clocks {CLOCK4_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK4_50}] -rise_to [get_clocks {CLOCK4_50}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {CLOCK4_50}] -fall_to [get_clocks {CLOCK4_50}] -setup 0.310  
set_clock_uncertainty -fall_from [get_clocks {CLOCK4_50}] -fall_to [get_clocks {CLOCK4_50}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {CLOCK3_50}] -rise_to [get_clocks {CLOCK3_50}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {CLOCK3_50}] -rise_to [get_clocks {CLOCK3_50}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {CLOCK3_50}] -fall_to [get_clocks {CLOCK3_50}] -setup 0.170  
set_clock_uncertainty -rise_from [get_clocks {CLOCK3_50}] -fall_to [get_clocks {CLOCK3_50}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {CLOCK3_50}] -rise_to [get_clocks {CLOCK3_50}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {CLOCK3_50}] -rise_to [get_clocks {CLOCK3_50}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {CLOCK3_50}] -fall_to [get_clocks {CLOCK3_50}] -setup 0.170  
set_clock_uncertainty -fall_from [get_clocks {CLOCK3_50}] -fall_to [get_clocks {CLOCK3_50}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[0]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[0]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[1]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[1]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[2]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[2]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[3]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[3]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[4]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[4]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[5]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[5]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[6]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[6]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[7]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[7]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[8]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[8]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[9]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[9]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[10]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[10]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[11]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[11]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[12]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[12]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[13]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[13]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[14]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[14]}]
set_input_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  5.900 [get_ports {DRAM_DQ[15]}]
set_input_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  3.000 [get_ports {DRAM_DQ[15]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[0]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[0]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[1]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[1]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[2]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[2]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[3]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[3]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[4]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[4]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[5]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[5]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[6]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[6]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[7]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[7]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[8]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[8]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_D[9]}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_D[9]}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_HS}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_HS}]
set_input_delay -add_delay -max -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  6.100 [get_ports {MIPI_PIXEL_VS}]
set_input_delay -add_delay -min -clock [get_clocks {MIPI_PIXEL_CLK_ext}]  0.900 [get_ports {MIPI_PIXEL_VS}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[2]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[3]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[4]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[5]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[6]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[7]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[7]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[8]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[8]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[9]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[9]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[10]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[10]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[11]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[11]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_ADDR[12]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_ADDR[12]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_BA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_BA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_BA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_BA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_CAS_N}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_CAS_N}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_CKE}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_CKE}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_CS_N}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_CS_N}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[2]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[3]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[4]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[5]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[6]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[7]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[7]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[8]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[8]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[9]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[9]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[10]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[10]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[11]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[11]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[12]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[12]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[13]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[13]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[14]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[14]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_DQ[15]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_DQ[15]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_LDQM}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_LDQM}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_RAS_N}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_RAS_N}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_UDQM}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_UDQM}]
set_output_delay -add_delay -max -clock [get_clocks {clk_dram_ext}]  1.600 [get_ports {DRAM_WE_N}]
set_output_delay -add_delay -min -clock [get_clocks {clk_dram_ext}]  -0.900 [get_ports {DRAM_WE_N}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_BLANK_N}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_BLANK_N}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[2]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[3]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[4]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[5]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[6]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_B[7]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_B[7]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[2]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[3]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[4]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[5]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[6]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_G[7]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_G[7]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[0]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[0]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[1]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[1]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[2]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[2]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[3]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[3]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[4]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[4]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[5]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[5]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[6]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[6]}]
set_output_delay -add_delay -max -clock [get_clocks {clk_vga_ext}]  0.300 [get_ports {VGA_R[7]}]
set_output_delay -add_delay -min -clock [get_clocks {clk_vga_ext}]  -1.600 [get_ports {VGA_R[7]}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {i_MIPI_PLL|mipi_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -group [get_clocks {MIPI_PIXEL_CLK}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_3f9:dffpipe14|dffe15a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_2f9:dffpipe5|dffe6a*}]
set_false_path -from [get_keepers {*rdptr_g*}] -to [get_keepers {*ws_dgrp|dffpipe_1f9:dffpipe22|dffe23a*}]
set_false_path -from [get_keepers {*delayed_wrptr_g*}] -to [get_keepers {*rs_dgwp|dffpipe_0f9:dffpipe13|dffe14a*}]
set_false_path -from [get_ports {KEY* SW*}] 
set_false_path -to [get_ports {LED* HEX*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_clocks {clk_dram_ext}] -to [get_pins {i_SDRAM_PLL|sdram_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 2


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

