module esp32tang_top(
    input         EXT_CLK,	//external clock
    input         EXT_RSTn,	//external reset signal, active low
    output        led_out 	//pwm LED output
    );

wire sys_clk;
wire spi_clk;
wire sys_rst_n;
wire pwm_led;

Gowin_rPLL pll_inst(
    // clock and reset input
    .clkin(EXT_CLK), //27M external clock input
    .reset(!EXT_RSTn),  // reset signal, active high
    // clock output
    .clkout(sys_clk), // 27M clock output
    .clkoutd3(spi_clk), //9M clock output
    //system reset, active low
    .lock(sys_rst_n)
    );

breath_led breath_led_inst(
    .clk(sys_clk),	//27M clock
    .rst(!sys_rst_n),	//active low reset
    .pwm_led_out(pwm_led)	//pwm output
    );


assign led_out= pwm_led;

endmodule 