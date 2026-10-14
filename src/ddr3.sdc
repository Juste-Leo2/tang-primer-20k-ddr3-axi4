// Timing Constraints file for Tang Primer 20K DDR3
// Primary input: 27 MHz onboard oscillator
create_clock -name sys_clk -period 37.037 -waveform {0 18.518} [get_ports {sys_clk}]

// Generated PLL clocks
create_clock -name pll_clkoutd -period 15.058 -waveform {0 7.529} [get_nets {pll_clkoutd}]
create_clock -name pll_clkout -period 3.767 -waveform {0 1.883} [get_nets {pll_clkout}]

set_clock_groups -asynchronous -group [get_clocks {pll_clkout}] -group [get_clocks {pll_clkoutd}]

report_timing -hold -from_clock [get_clocks {pll_clkout*}] -to_clock [get_clocks {pll_clkout*}] -max_paths 25 -max_common_paths 1
report_timing -setup -from_clock [get_clocks {pll_clkout*}] -to_clock [get_clocks {pll_clkout*}] -max_paths 25 -max_common_paths 1
