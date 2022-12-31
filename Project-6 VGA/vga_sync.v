//Drives HSync and Vsync according to the VGA standard with F/B Porches.
//Video signal is delayed to match the sync signal delay.

module VGA_Sync 
  #(parameter COLOR_BITS = 3) //used in input desc

  (input i_Clk,
   input [9:0] i_Col_Count,
   input [9:0] i_Row_Count,
   input [COLOR_BITS-1:0] i_Red_Video,
   input [COLOR_BITS-1:0] i_Grn_Video,
   input [COLOR_BITS-1:0] i_Blu_Video,
   output reg o_HSync,
   output reg o_VSync,
   output reg [COLOR_BITS-1:0] o_Red_Video,
   output reg [COLOR_BITS-1:0] o_Grn_Video,
   output reg [COLOR_BITS-1:0] o_Blu_Video
   );

  parameter TOTAL_COLS  = 800;
  parameter TOTAL_ROWS  = 525;
  parameter ACTIVE_COLS = 640;
  parameter ACTIVE_ROWS = 480;

  parameter c_FRONT_PORCH_HORZ = 18;
  parameter c_BACK_PORCH_HORZ  = 50;
  parameter c_FRONT_PORCH_VERT = 10;
  parameter c_BACK_PORCH_VERT  = 33;

  reg [COLOR_BITS-1:0] r_Red_Video = 0;
  reg [COLOR_BITS-1:0] r_Grn_Video = 0;
  reg [COLOR_BITS-1:0] r_Blu_Video = 0;
    
  // Purpose: Modifies the HSync and VSync signals to include Front/Back Porch
  always @(posedge i_Clk)
  begin
    if ((i_Col_Count < c_FRONT_PORCH_HORZ + ACTIVE_COLS) || 
        (i_Col_Count > TOTAL_COLS - c_BACK_PORCH_HORZ - 1))
      o_HSync <= 1'b1;
    else
      o_HSync <= 1'b0;
    
    if ((i_Row_Count < c_FRONT_PORCH_VERT + ACTIVE_ROWS) ||
        (i_Row_Count > TOTAL_ROWS - c_BACK_PORCH_VERT - 1))
      o_VSync <= 1'b1;
    else
      o_VSync <= 1'b0;
  end

  
  // Purpose: Align input video to modified Sync pulses.
  // Adds in 2 Clock Cycles of Delay
  always @(posedge i_Clk)
  begin
    r_Red_Video <= i_Red_Video;
    r_Grn_Video <= i_Grn_Video;
    r_Blu_Video <= i_Blu_Video;

    o_Red_Video <= r_Red_Video;
    o_Grn_Video <= r_Grn_Video;
    o_Blu_Video <= r_Blu_Video;
  end
  
endmodule
