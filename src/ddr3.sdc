// Timing Constraints file for Tang Primer 20K DDR3
// Primary input: 27 MHz onboard oscillator
create_clock -name sys_clk -period 37.037 -waveform {0 18.518} [get_ports {sys_clk}]

// Generated PLL clocks (303.75 MHz fclk / 75.9375 MHz pclk)
create_clock -name pll_clkoutd -period 13.168 -waveform {0 6.584} [get_pins {*rpll_inst/CLKOUTD}]
create_clock -name pll_clkout -period 3.292 -waveform {0 1.646} [get_pins {*rpll_inst/CLKOUT}]

set_clock_groups -asynchronous -group [get_clocks {pll_clkout}] -group [get_clocks {pll_clkoutd}]
set_clock_groups -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks {pll_clkout*}]

report_timing -hold -from_clock [get_clocks {pll_clkout*}] -to_clock [get_clocks {pll_clkout*}] -max_paths 25 -max_common_paths 1
report_timing -setup -from_clock [get_clocks {pll_clkout*}] -to_clock [get_clocks {pll_clkout*}] -max_paths 25 -max_common_paths 1
