module GoBoard (
  //Main FPGA Clock
  input i_Clk,
   
  //LED Pins
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4,

  //Push-Button Switches
  input i_Switch_1,
  input i_Switch_2,
  input i_Switch_3,
  input i_Switch_4);

assign o_LED_1 = i_Switch_1 & i_Switch_2;
assign o_LED_2 = i_Switch_3 | i_Switch_4;
assign o_LED_3 = 0;
assign o_LED_4 = 1;

endmodule