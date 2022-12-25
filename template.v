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
  input i_Switch_4,

  //7 Segment 1
  output o_Segment1_A,
  output o_Segment1_B,
  output o_Segment1_C,
  output o_Segment1_D,
  output o_Segment1_E,
  output o_Segment1_F,
  output o_Segment1_G,

  //7 Segment 2
  output o_Segment2_A,
  output o_Segment2_B,
  output o_Segment2_C,
  output o_Segment2_D,
  output o_Segment2_E,
  output o_Segment2_F,
  output o_Segment2_G,

  //Serial
  input i_UART_RX,
  output o_UART_TX,

  //VGA
  
  output o_VGA_HSync,
  output o_VGA_VSync,
  output o_VGA_Red_0,
  output o_VGA_Red_1,
  output o_VGA_Red_2,
  output o_VGA_Grn_0,
  output o_VGA_Grn_1,
  output o_VGA_Grn_2,
  output o_VGA_Blu_0,
  output o_VGA_Blu_1,
  output o_VGA_Blu_2,

  //GPIO / PMOD
  inout io_PMOD_1,
  inout io_PMOD_2,
  inout io_PMOD_3,
  inout io_PMOD_4,
  inout io_PMOD_7,
  inout io_PMOD_8,
  inout io_PMOD_9,
  inout io_PMOD_10);

assign o_LED_1 = i_Switch_1;
assign o_LED_2 = i_Switch_2;
assign o_LED_3 = i_Switch_3;
assign o_LED_4 = i_Switch_4;
  
endmodule